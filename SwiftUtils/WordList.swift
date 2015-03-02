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
    private let MIN_ANAGRAM_LENGTH = 3
    private let SUBANAGRAM_DEPTH = 3
    public var resultsLimit = 500
    public var wordlist: [String]!
    private var count = 0

    //Stop needs to be protected by a mutex,
    //keep an eye out for future enhancements in Swift, such as synchronized blocks
    private var _Stop = false
    private var stop: Bool
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
    
    public func reset()
    {
        stop = false
        self.count = 0
    }
    
    public func findSupergrams(letters: String, callback: WordListCallback, length: Int)
    {
        let len = letters.utf16Count
        let anagram = LetterSet(word: letters)
        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            if (length==0 && word.utf16Count>len) || word.utf16Count == length
            {
                if anagram.isSupergram(word)
                {
                    callback.update(word)
                    self.count++
                    if self.count == self.resultsLimit
                    {
                        break
                    }
                }
            }
        }
    }
    public func findAnagrams(letters: String, callback: WordListCallback)
    {
        let len = letters.utf16Count
        let anagram = LetterSet(word: letters)
        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            if word.utf16Count == len
            {
                if anagram.isAnagram(word)
                {
                    callback.update(word)
                    self.count++
                    if self.count == self.resultsLimit
                    {
                        break
                    }
                }
            }
        }
    }
    public func findSubAnagrams(letters: String, callback: WordListCallback)
    {
        let len = letters.utf16Count
        let anagram = LetterSet(word: letters)
        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            let wordLen = word.utf16Count
            if wordLen>self.MIN_ANAGRAM_LENGTH && wordLen < len
            {
                if anagram.isSubgram(word)
                {
                    callback.update(word)
                    self.count++
                    if self.count == self.resultsLimit
                    {
                        break
                    }
                }
            }
        }
    }

    public func findCrosswords(crossword: String, callback: WordListCallback)
    {
        let len = crossword.utf16Count
        let pattern = createRegexPattern(crossword)
        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            if word.utf16Count == len
            {
                if word.rangeOfString(pattern, options:NSStringCompareOptions.RegularExpressionSearch) != nil
                {
                    callback.update(word)
                    self.count++
                    if self.count == self.resultsLimit
                    {
                        break
                    }
                }
            }
        }
    }
    public func findWildcards(wildcard: String, callback: WordListCallback)
    {
        let pattern = createRegexPattern(wildcard)
        for word in self.wordlist
        {
            if (self.stop)
            {
                break
            }
            if word.rangeOfString(pattern, options:NSStringCompareOptions.RegularExpressionSearch) != nil
            {
                callback.update(word)
                self.count++
                if self.count == self.resultsLimit
                {
                    break
                }
            }
        }
    }
    private func createRegexPattern(var query: String) ->String
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
    public func findMultiwordAnagrams(word1: String, word2: String, callback: WordListCallback)
    {
        let superset = LetterSet(word: word1+word2)
        var listA = self.getFilteredList(superset, length: word1.utf16Count)
        var listB: [String]
        if word1.utf16Count == word2.utf16Count
        {
            listB = listA
        }
        else
        {
            listB = self.getFilteredList(superset, length: word2.utf16Count)
        }
        //maybe swap lists depending on size
        if listA.count > listB.count
        {
            let swap = listA
            listA = listB
            listB = swap
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
                    self.count++
                    if self.count == self.resultsLimit
                    {
                        return
                    }
                }
            }
        }
        
    }
    private func getFilteredList(set: LetterSet, length: Int) -> [String]{
        var matches : [String] = []
        for word in self.wordlist
        {
            if word.utf16Count == length && set.isSubgram(word)
            {
                matches.append(word)
            }
        }
        return matches
    }
    
    
}