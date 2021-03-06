//
//  WordSearch.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 09/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import Foundation

public enum SearchType : CaseIterable
{
    case crossword
    case anagram
    case twoWordAnagram
    case wildcard
    case wildcardAndCrossword
    case blanks
    case supergram
    case codeword
}

public class WordSearch
{
    public var findSubAnagrams = true
    public var findThreeWordAnagrams = true
    public var findCodewords = true
    private var wordList : WordList? = nil
    private lazy var codewordSolver = CodewordSolver()
    private let usLocale = Locale(identifier: "en_US")

    public let MAX_WORD_LEN = 42
    static public let CROSSWORD_STR = "."
    static public let CROSSWORD_STR_ALT = "?"
    static public let TWO_WORD_STR = " "
    static public let TWO_WORD_STR_ALT1 = "-"
    static public let TWO_WORD_STR_ALT2 = ","
    static public let WILDCARD_STR = "@"
    static public let BLANK_STR = "+"
    static public let SUPERGRAM_STR = "*"

    private let CROSSWORD_CHAR_VALUE = UnicodeScalar(".").value
    private let TWO_WORD_CHAR_VALUE = UnicodeScalar(" ").value
    private let WILDCARD_CHAR_VALUE = UnicodeScalar("@").value
    private let BLANK_CHAR_VALUE = UnicodeScalar("+").value
    private let SUPERGRAM_VALUE = UnicodeScalar("*").value
    private let CODEWORD_CHAR = UnicodeScalar("1")
    private let LOWEST_CHAR_VALUE = UnicodeScalar("a").value
    private let HIGHEST_CHAR_VALUE = UnicodeScalar("z").value

    private let LOWEST_ASCII_VALUE = UnicodeScalar(" ").value
    private let HIGHEST_ASCII_VALUE = UnicodeScalar("z").value

    public class func getGoogleUrl(word : String)->String{
        return "https://www.google.com/search?q=dictionary:\(word)"
    }
    public class func getGoogleDefineUrl(word : String)->String{
        return "https://www.google.com/search?q=define:\(word)"
    }
    public class func getMerriamWebsterUrl(word : String)->String{
        return "https://www.merriam-webster.com/dictionary/\(word)"
    }
    public class func getMWThesaurusUrl(word : String)->String{
        return "https://www.merriam-webster.com/thesaurus/\(word)"
    }
    public class func getCollinsUrl(word : String)->String{
        let processed = word.replace(" ", withString: "-")
        return "https://www.collinsdictionary.com/dictionary/english/\(processed)"
    }
    public class func getLexicoUrl(word : String)->String{
        return "https://www.lexico.com/en/definition/\(word)"
    }
    public class func getDictionaryComUrl(word : String)->String{
        return "https://www.dictionary.com/browse/\(word)"
    }
    public class func getThesaurusComUrl(word : String)->String{
        return "https://www.thesaurus.com/browse/\(word)"
    }
    public class func getWikipediaUrl(word : String)->String{
        let processed = word.replace(" ", withString: "_")
        return "https://en.wikipedia.org/wiki/\(processed)"
    }
    public class func getWordGameDictionaryUrl(word : String)->String{
        return "https://www.wordgamedictionary.com/dictionary/word/\(word)"
    }
    public class func getChambersUrl(word : String)->String{
        let processed = word.replace(" ", withString: "+")
        return "https://chambers.co.uk/search/?query=\(processed)&title=21st"
    }
    public class func getWiktionaryUrl(word : String)->String{
        let processed = word.replace(" ", withString: "_")
        return "https://en.wiktionary.org/wiki/\(processed)"
    }
    public class func getCambridgeUrl(word : String)->String{
        let processed = word.replace(" ", withString: "-")
        return "https://dictionary.cambridge.org/dictionary/english/\(processed)"
    }
    
    public init(){}
    
    public func loadDictionary(resource : String) -> Bool {
        if let path = Bundle.main.path(forResource: resource, ofType: "txt"),
           let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) {
            let words = content.components(separatedBy: "\n")
            self.wordList = WordList(wordlist: words)
            return true
        }
        return false
    }
    
    public func unloadDictionary(){
        self.wordList = nil
    }
    
    /*
        Remove non-ascii chars
        Chop down to max length
        Trim whitespace
        Lowercase
    */
    public func clean(_ raw: String)->String
    {
        if raw.length==0
        {
            return ""
        }
        var builder =  ""
        let chars = raw
            .trimmingCharacters(in: CharacterSet.whitespaces)
            .unicodeScalars
        for c in chars
        {
            let v = c.value
            if v>=LOWEST_ASCII_VALUE && v<=HIGHEST_ASCII_VALUE
            {
                builder.append(String(c))
            }
            if builder.length > MAX_WORD_LEN
            {
                break
            }
        }
        builder = builder.trimmingCharacters(in: CharacterSet.whitespaces)
        
        return builder.lowercased()
    }
  
    public func preProcessQuery(_ query: String)->String
    {
        var processedQuery : String
        if isCodeword(query: query){
            processedQuery = query
                .lowercased(with: usLocale)
                .replace(WordSearch.CROSSWORD_STR_ALT, withString: WordSearch.CROSSWORD_STR)
        } else {
            processedQuery = query
                .lowercased(with: usLocale)
                .replace(WordSearch.CROSSWORD_STR_ALT, withString: WordSearch.CROSSWORD_STR)
                .replace(WordSearch.TWO_WORD_STR_ALT1, withString: WordSearch.TWO_WORD_STR)
                .replace(WordSearch.TWO_WORD_STR_ALT2, withString: WordSearch.TWO_WORD_STR)
                .replace("1", withString: ".")
                .replace("2", withString: "..")
                .replace("3", withString: "...")
                .replace("4", withString: "....")
                .replace("5", withString: ".....")
                .replace("6", withString: "......")
                .replace("7", withString: ".......")
                .replace("8", withString: "........")
                .replace("9", withString: ".........")
        }
        if processedQuery.length > MAX_WORD_LEN
        {
            processedQuery = processedQuery[0..<MAX_WORD_LEN]
        }
        
        return processedQuery
    }
    
    public func getQueryType(_ query: String) ->SearchType
    {
        if query.mpdb_contains(WordSearch.WILDCARD_STR) && query.mpdb_contains(WordSearch.CROSSWORD_STR)
        {
            return SearchType.wildcardAndCrossword
        }
        else if query.mpdb_contains(WordSearch.WILDCARD_STR)
        {
            return SearchType.wildcard
        }
        else if isCodeword(query: query)
        {
            return SearchType.codeword
        }
        else if query.mpdb_contains(WordSearch.CROSSWORD_STR)
        {
            return SearchType.crossword
        }
        else if query.mpdb_contains(WordSearch.TWO_WORD_STR)
        {
            return SearchType.twoWordAnagram
        }
        else if query.mpdb_contains(WordSearch.BLANK_STR)
        {
            return SearchType.blanks
        }
        else if query.mpdb_contains(WordSearch.SUPERGRAM_STR)
        {
            return SearchType.supergram
        }
        return SearchType.anagram
    }

    public func postProcessQuery(_ query: String, type: SearchType)->String
    {
        var query = query
        switch type
        {
        case .anagram:
            //keep a-z but remove any other char
            query = stripChars(query)
        case .crossword:
            //keep a-z and .
            query = stripChars(query, except1: CROSSWORD_CHAR_VALUE)
        case .blanks:
            //keep a-z and +
            query = stripChars(query, except1: BLANK_CHAR_VALUE)
        case .supergram:
            //keep a-z and *
            query = stripChars(query, except1: SUPERGRAM_VALUE)
        case .twoWordAnagram:
            //keep a-z and ' '
            query = stripChars(query, except1: TWO_WORD_CHAR_VALUE)
        case .wildcard:
            //keep a-z and @
            query = stripChars(query, except1: WILDCARD_CHAR_VALUE)
        case .wildcardAndCrossword:
            //keep a-z . @
            query = stripChars(query, except1: CROSSWORD_CHAR_VALUE, except2: WILDCARD_CHAR_VALUE)
        case .codeword:
            query = stripCharsForCodeword(query)
        }
        return query
    }
    
    private func stripChars(_ s: String, except1: UInt32 = 0, except2: UInt32 = 0)->String
    {
        var builder =  ""
        let chars = s.unicodeScalars
        for c in chars
        {
            let v = c.value
            if (v>=LOWEST_CHAR_VALUE && v<=HIGHEST_CHAR_VALUE) || v == except1 || v == except2
            {
                builder.append(String(c))
            }
        }
        return builder
    }
    
    private func stripCharsForCodeword(_ s: String) -> String
    {
        //Codewords can use numbers 1 to 7 to represent letters
        let CHAR_1 = UnicodeScalar("1").value
        let CHAR_7 = UnicodeScalar("7").value
        var builder =  ""
        let chars = s.unicodeScalars
        for c in chars
        {
            let v = c.value
            if (v>=LOWEST_CHAR_VALUE && v<=HIGHEST_CHAR_VALUE) || (v>=CHAR_1 && v<=CHAR_7) || v == CROSSWORD_CHAR_VALUE
            {
                builder.append(String(c))
            }
        }
        return builder
    }
    
    public func runQuery(_ query: String, type: SearchType, callback: WordListCallback)
    {
        let len = query.length
        if let wl = self.wordList, len > 0 {
            wl.reset()
            switch type
            {
            case .anagram:
                wl.findAnagrams(query, callback: callback)
                if self.findSubAnagrams && len<=self.MAX_WORD_LEN
                {
                    //don't show the same word twice
                    let filterWrapper = WordListFilterWrapper(callback: callback)
                    wl.findSubAnagrams(query, callback: filterWrapper)
                }
            case .crossword:
                wl.findCrosswords(query, callback: callback)
            case .blanks:
                let queryRemovedSymbol = query.replace(WordSearch.BLANK_STR, withString: "")
                let numberOfBlanks = len - queryRemovedSymbol.length
                if self.findSubAnagrams {
                    wl.findAnagrams(queryRemovedSymbol, numberOfBlanks: numberOfBlanks, callback: callback)
                } else {
                    wl.findAnagramsExactLength(queryRemovedSymbol, numberOfBlanks: numberOfBlanks, callback: callback)
                }
            case .supergram:
                let queryRemovedSymbol = query.replace(WordSearch.SUPERGRAM_STR, withString: "")
                wl.findSupergrams(queryRemovedSymbol, callback: callback, length: 0)
            case .twoWordAnagram:
                let words = query.split(separator: " ")
                if self.findThreeWordAnagrams && words.count > 2 {
                    wl.findMultiwordAnagrams(String(words[0]), String(words[1]), String(words[2]), callback: callback)
                } else if words.count >= 2 {
                    wl.findMultiwordAnagrams(String(words[0]+words[1]), startLen: words[0].count, callback: callback)
                }
            case .wildcard, .wildcardAndCrossword:
                wl.findWildcards(query, callback: callback)
            case .codeword:
                self.codewordSolver.parse(query: query)
                wl.findCodewords(codewordSolver: codewordSolver, callback: callback)
            }
        }
    }
    
    public func stop(){
        wordList?.stopSearch()
    }
    
    private func isCodeword(query : String) -> Bool {
        return findCodewords && query.unicodeScalars.filter({$0==CODEWORD_CHAR}).count>1
    }
    
}
