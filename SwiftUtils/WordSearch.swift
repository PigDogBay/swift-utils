//
//  WordSearch.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 09/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import Foundation

public enum SearchType
{
    case Crossword
    case Anagram
    case TwoWordAnagram
    case Wildcard
    case WildcardAndCrossword
    case Supergram
    case SupergramWild
}

public class WordSearch
{
    public var findSubAnagrams = true
    public let wordList : WordList!
    private let usLocale = NSLocale(localeIdentifier: "en_US")

    public let MAX_WORD_LEN = 30
    public let CROSSWORD_STR = "."
    public let TWO_WORD_STR = " "
    public let WILDCARD_STR = "@"
    public let SUPERGRAM_STR = "+"
    public let SUPERGRAM_WILD_STR = "*"
    
    private let CROSSWORD_CHAR_VALUE = UnicodeScalar(".").value
    private let TWO_WORD_CHAR_VALUE = UnicodeScalar(" ").value
    private let WILDCARD_CHAR_VALUE = UnicodeScalar("@").value
    private let SUPERGRAM_CHAR_VALUE = UnicodeScalar("+").value
    private let SUPERGRAM_WILD_VALUE = UnicodeScalar("*").value
    private let LOWEST_CHAR_VALUE = UnicodeScalar("a").value
    private let HIGHEST_CHAR_VALUE = UnicodeScalar("z").value
    
    public init(wordList: WordList)
    {
        self.wordList = wordList
    }
    
    public func preProcessQuery(var query: String)->String
    {
        query = query
            .lowercaseStringWithLocale(usLocale)
            .replace("?", withString: ".")
            .replace("2", withString: "..")
            .replace("3", withString: "...")
            .replace("4", withString: "....")
            .replace("5", withString: ".....")
            .replace("6", withString: "......")
            .replace("7", withString: ".......")
            .replace("8", withString: "........")
            .replace("9", withString: ".........")
        
        if query.utf16Count > MAX_WORD_LEN
        {
            query = query[0..<MAX_WORD_LEN]
        }
        
        return query
    }
    
    public func getQueryType(query: String) ->SearchType
    {
        if query.mpdb_contains(WILDCARD_STR) && query.mpdb_contains(CROSSWORD_STR)
        {
            return SearchType.WildcardAndCrossword
        }
        else if query.mpdb_contains(WILDCARD_STR)
        {
            return SearchType.Wildcard
        }
        else if query.mpdb_contains(CROSSWORD_STR)
        {
            return SearchType.Crossword
        }
        else if query.mpdb_contains(TWO_WORD_STR)
        {
            return SearchType.TwoWordAnagram
        }
        else if query.mpdb_contains(SUPERGRAM_STR)
        {
            return SearchType.Supergram
        }
        else if query.mpdb_contains(SUPERGRAM_WILD_STR)
        {
            return SearchType.SupergramWild
        }
        return SearchType.Anagram
    }

    public func postProcessQuery(var query: String, type: SearchType)->String
    {
        switch type
        {
        case .Anagram:
            //keep a-z but remove any other char
            query = stripChars(query)
        case .Crossword:
            //keep a-z and .
            query = stripChars(query, except1: CROSSWORD_CHAR_VALUE)
        case .Supergram:
            //keep a-z and +
            query = stripChars(query, except1: SUPERGRAM_CHAR_VALUE)
        case .SupergramWild:
            //keep a-z and *
            query = stripChars(query, except1: SUPERGRAM_WILD_VALUE)
        case .TwoWordAnagram:
            //keep a-z and ' '
            query = stripChars(query, except1: TWO_WORD_CHAR_VALUE)
        case .Wildcard:
            //keep a-z and @
            query = stripChars(query, except1: WILDCARD_CHAR_VALUE)
        case .WildcardAndCrossword:
            //keep a-z . @
            query = stripChars(query, except1: CROSSWORD_CHAR_VALUE, except2: WILDCARD_CHAR_VALUE)
        }
        return query
    }
    private func stripChars(s: String, except1: UInt32 = 0, except2: UInt32 = 0)->String
    {
        var builder =  ""
        let chars = s.unicodeScalars
        for c in chars
        {
            let v = c.value
            if (v>=LOWEST_CHAR_VALUE && v<=HIGHEST_CHAR_VALUE) || v == except1 || v == except2
            {
                builder.append(c)
            }
        }
        return builder
    }
    public func runQuery(query: String, type: SearchType, callback: WordListCallback)
    {
        let len = query.utf16Count
        self.wordList.reset()
        switch type
        {
        case .Anagram:
            self.wordList.findAnagrams(query, callback: callback)
            if self.findSubAnagrams && len>4 && len<self.MAX_WORD_LEN
            {
                //show the unused letters in brackets
                let missingLetterWrapper = WordListMissingLetterWrapper(callback: callback, originalWord: query)
                //don't show the same word twice
                let filterWrapper = WordListFilterWrapper(callback: missingLetterWrapper)
                self.wordList.findSubAnagrams(query, callback: filterWrapper)
            }
        case .Crossword:
            self.wordList.findCrosswords(query, callback: callback)
        case .Supergram:
            let queryRemovedSymbol = query.replace("+", withString: "")
            self.wordList.findSupergrams(queryRemovedSymbol, callback: callback, length: len)
        case .SupergramWild:
            let queryRemovedSymbol = query.replace("*", withString: "")
            self.wordList.findSupergrams(queryRemovedSymbol, callback: callback, length: 0)
        case .TwoWordAnagram:
            let words = split(query){$0==" "}
            self.wordList.findMultiwordAnagrams(words[0], word2: words[1], callback: callback)
        case .Wildcard, .WildcardAndCrossword:
            self.wordList.findWildcards(query, callback: callback)
        }
    }
    
    
    
}