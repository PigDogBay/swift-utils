//
//  WordList.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 09/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import Foundation

open class WordList
{
    open var wordlist: [String]!

    //Stop needs to be protected by a mutex,
    //keep an eye out for future enhancements in Swift, such as synchronized blocks
    fileprivate var _Stop = false
    fileprivate var stop: Bool
    {
        get
        {
            objc_sync_enter(self)
            let tmp = _Stop
            objc_sync_exit(self)
            return tmp
        }
        set(newValue)
        {
            objc_sync_enter(self)
            _Stop = newValue
            objc_sync_exit(self)
        }
    }
    open func stopSearch()
    {
        stop = true
    }
    public init()
    {
    }
    public init(wordlist: [String])
    {
        self.wordlist = wordlist
    }
    /*
        Adds the new words to the exisiting list and then
        sorts by length, but for equal length words sort alphabetically
        
        Unfortunately the sort for added pro words to the std words
        takes over 30s on the iPad
    */
    open func addNewWords(_ newWords: [String])
    {
        wordlist.append(contentsOf: newWords)
        wordlist.sort(by: { (str1, str2) -> Bool in
                let len1 = str1.length
                let len2 = str2.length
                if len1==len2 {
                    return str1.compare(str2) == .orderedAscending
                }
                return len1>len2
            })
    }
    
    open func reset()
    {
        stop = false
    }
    
    open func findSupergrams(_ letters: String, callback: WordListCallback, length: Int)
    {
        let len = letters.length
        let anagram = LetterSet(word: letters)
        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            if (length==0 && word.length>len) || word.length == length
            {
                if anagram.isSupergram(word)
                {
                    callback.update(word)
                }
            }
        }
    }
    open func findAnagrams(_ letters: String, numberOfBlanks: Int, callback: WordListCallback)
    {
        let len = letters.length
        let anagram = LetterSet(word: letters)
        let too_big = len + numberOfBlanks + 1
        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            if word.length < too_big {
                if anagram.isAnagram(word, numberOfBlanks: numberOfBlanks){
                    callback.update(word)
                }
            }
        }
    }

    open func findAnagrams(_ letters: String, callback: WordListCallback)
    {
        let len = letters.length
        let anagram = LetterSet(word: letters)
        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            if word.length == len
            {
                if anagram.isAnagram(word)
                {
                    callback.update(word)
                }
            }
        }
    }
    open func findSubAnagrams(_ letters: String, callback: WordListCallback)
    {
        let len = letters.length
        let anagram = LetterSet(word: letters)
        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            let wordLen = word.length
            if wordLen>0 && wordLen < len
            {
                if anagram.isSubgram(word)
                {
                    callback.update(word)
                }
            }
        }
    }

    open func findCrosswords(_ crossword: String, callback: WordListCallback)
    {
        let len = crossword.length
        let pattern = createRegexPattern(crossword)
        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            if word.length == len
            {
                if word.range(of: pattern, options:NSString.CompareOptions.regularExpression) != nil
                {
                    callback.update(word)
                }
            }
        }
    }
    open func findWildcards(_ wildcard: String, callback: WordListCallback)
    {
        let pattern = createRegexPattern(wildcard)
        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            if word.range(of: pattern, options:NSString.CompareOptions.regularExpression) != nil
            {
                callback.update(word)
            }
        }
    }
    fileprivate func createRegexPattern(_ query: String) ->String
    {
        //need to add word boundary to prevent regex matching just part of the word string
        return "\\b"+query
            .replace(".", withString: "[a-z]")
            .replace("@", withString: "[a-z]+")+"\\b"
    }
    /*
        Filter the word list so that it contains letters that are same size as word1
        and is a subset of the letters contained in word1+word2
        
        Create another filtered list if word2 is different length to word1
    
        swap lists, we want the smallest to cut down on some processing
    
        for each word in the first list find the unused letters
        
        Then for each word in the second list see if it is an anagram of the unused letters,
        if it is the first and second words make a two word anagram
    */
    open func findMultiwordAnagrams(_ word1: String, word2: String, callback: WordListCallback)
    {
        let superset = LetterSet(word: word1+word2)
        let listA = self.getFilteredList(superset, length: word1.length)
        var listB: [String]
        if word1.length == word2.length
        {
            listB = listA
        }
        else
        {
            listB = self.getFilteredList(superset, length: word2.length)
        }
        for first in listA
        {
            superset.clear()
            superset.add(word1)
            superset.add(word2)
            superset.delete(first)
            for second in listB
            {
                if (self.stop)
                {
                    break
                }
                if superset.isAnagram(second)
                {
                    callback.update(first+" "+second)
                }
            }
        }
    }
    open func findMultiwordAnagrams(_ letters: String, startLen : Int, callback: WordListCallback){
        let len = letters.count
        let middleWordSize = len/2
        
        //first show the user's requested word sizes
        findOtherMultiwordAnagrams(letters, startLen, callback: callback)
        
        let skipLen = startLen > middleWordSize ? len - startLen : startLen
        for i in stride(from: middleWordSize, to: 0, by: -1) {
            if (self.stop) { break }
            if i != skipLen {
                findOtherMultiwordAnagrams(letters, i, callback: callback)
            }
        }
    }

    fileprivate func findOtherMultiwordAnagrams(_ letters : String,_ i : Int, callback : WordListCallback) {
        let index = letters.index(letters.startIndex, offsetBy: i)
        let word1 = String(letters[..<index])
        let word2 = String(letters[index...])
        findMultiwordAnagrams(word1, word2: word2, callback: callback)
    }
    
    fileprivate func getFilteredList(_ set: LetterSet, length: Int) -> [String]{
        var matches : [String] = []
        for word in self.wordlist
        {
            if word.length == length && set.isSubgram(word)
            {
                matches.append(word)
            }
        }
        return matches
    }
    
    
}
