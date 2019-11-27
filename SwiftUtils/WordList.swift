//
//  WordList.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 09/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import Foundation

public class WordList
{
    public var wordlist: [String]!

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
    public func stopSearch()
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
    public func addNewWords(_ newWords: [String])
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
    
    public func reset()
    {
        stop = false
    }
    
    public func findSupergrams(_ letters: String, callback: WordListCallback, length: Int)
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
    public func findAnagrams(_ letters: String, numberOfBlanks: Int, callback: WordListCallback)
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
    public func findAnagramsExactLength(_ letters: String, numberOfBlanks: Int, callback: WordListCallback)
    {
        let len = letters.length + numberOfBlanks
        let anagram = LetterSet(word: letters)
        for word in self.wordlist
        {
            if (self.stop) { break }
            if word.length == len {
                if anagram.isAnagram(word, numberOfBlanks: numberOfBlanks){
                    callback.update(word)
                }
            }
        }
    }

    public func findAnagrams(_ letters: String, callback: WordListCallback)
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
    public func findSubAnagrams(_ letters: String, callback: WordListCallback)
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

    /*
     Speed Tests
     -----------
     Searching for .....ing returns 2543 matches
     word.range(of: pattern, options:NSString.CompareOptions.regularExpression)
     -Time taken 5.7s
     
     NSRegularExpression
     -Time taken 4.4s
     
     In unit testing, NSRegEx is over twice as fast.

     */
    public func findCrosswords(_ crossword: String, callback: WordListCallback)
    {
        let len = crossword.length
        let pattern = createRegexPattern(crossword)
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        if nil == regex {return}
        let range = NSRange(location: 0, length: len)

        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            if word.length == len
            {
                if 1 == regex!.numberOfMatches(in: word, options: [], range: range){
                    callback.update(word)
                }
            }
        }
    }
    /*
     Speed Tests
     -----------
    
     Unit tests show NSRegEx is 3x faster than NSString
     iPhone 5s Device tests: 16s for NSString, 10s for NSRegEx
     */
    public func findWildcards(_ wildcard: String, callback: WordListCallback)
    {
        let pattern = createRegexPattern(wildcard)
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        if nil == regex {return}

        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            let range = NSRange(location: 0, length: word.length)
            if 1 == regex!.numberOfMatches(in: word, options: [], range: range){
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
    public func findMultiwordAnagrams(_ word1: String, word2: String, callback: WordListCallback)
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
    public func findMultiwordAnagrams(_ letters: String, startLen : Int, callback: WordListCallback){
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
            if (self.stop) { break }
            if word.length == length && set.isSubgram(word)
            {
                matches.append(word)
            }
        }
        return matches
    }
    public func findMultiwordAnagrams(_ word1: String,_ word2: String,_ word3: String, callback: WordListCallback){
        let superset = LetterSet(word: word1+word2+word3)
        let listA = self.getFilteredList(superset, length: word1.length)
        var listB: [String]
        var listC: [String]
        if word1.length == word2.length {
            //In swift arrays are structs, so listA is copied here
            listB = listA
        } else {
            listB = self.getFilteredList(superset, length: word2.length)
        }
        
        if word3.length == word1.length
        {
            listC = listA
        } else if word3.length == word2.length {
            listC = listB
        } else {
            listC = self.getFilteredList(superset, length: word3.length)
        }
        var sublistB : [String] = []
        var sublistC : [String] = []
        let are2And3SameLength = word2.length == word3.length
        
        for first in listA {
            //prune lists B and C of any words that are impossible with first
            superset.clear()
            superset.add(word1)
            superset.add(word2)
            superset.add(word3)
            superset.delete(first)
            sublistB.removeAll()
            filterList(set: superset, length: word2.length, matches: &sublistB, wordList: listB)
            sublistC.removeAll()
            if are2And3SameLength {
                //Ideally in the case sublistC and sublistB would be the same array
                //however in swift they are structs, so are copied if you assign to a new instance.
                //I could use NSMutableArray but requires downcasting of the objects to Strings
                //or wrap the [String] in a class and use inout
                sublistC.append(contentsOf: sublistB)
            } else {
                filterList(set: superset, length: word3.length, matches: &sublistC, wordList: listC)
            }
            for second in sublistB {
                superset.clear()
                superset.add(word1)
                superset.add(word2)
                superset.add(word3)
                superset.delete(first)
                superset.delete(second)
                for third in sublistC {
                    if (self.stop) { break }
                    if superset.isAnagram(third){
                        callback.update("\(first) \(second) \(third)")
                    }
                }
            }
        }
    }
    
    func filterList(set : LetterSet, length : Int, matches : inout [String], wordList : [String]){
        for word in wordList {
            if (self.stop) { break }
            if word.length == length && set.isSubgram(word) {
                matches.append(word)
            }
        }
    }
    
    public func findCodewords(codewordSolver : CodewordSolver, callback : WordListCallback){
        for word in self.wordlist
        {
            if (self.stop) { break}
            if codewordSolver.isMatch(word: word){
               callback.update(word)
            }
        }
    }
}
