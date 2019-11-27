//
//  WordListCallback.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 09/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import Foundation

public protocol WordListCallback
{
    func update(_ result: String)
}

public class WordListFilterWrapper : WordListCallback
{
    //should callback be weak?
    private let callback : WordListCallback!
    private var matches: [String] = []
    
    public init(callback: WordListCallback)
    {
        self.callback = callback
    }
    public func update(_ result: String)
    {
        if (!matches.contains(result))
        {
            matches.append(result)
            callback.update(result)
        }
    }
}


public class WordListMissingLetterWrapper : WordListCallback
{
    private let callback : WordListCallback!
    private let originalWord : String!
    
    public init(callback: WordListCallback, originalWord: String)
    {
        self.callback = callback
        self.originalWord = originalWord
    }
    
    public func update(_ result: String)
    {
        let missingLetters = originalWord.subtractLetters(result)
        callback.update("\(result) (\(missingLetters))")
    }
}

public class BiggerThanFilter : WordListCallback {
    private let callback : WordListCallback
    private let size : Int
    
    public init(callback : WordListCallback, size : Int){
        self.callback = callback
        self.size = size
    }
    public func update(_ result: String)
    {
        if result.count > size {
            callback.update(result)
        }
    }
}

public class LessThanFilter : WordListCallback {
    private let callback : WordListCallback
    private let size : Int
    
    public init(callback : WordListCallback, size : Int){
        self.callback = callback
        self.size = size
    }
    public func update(_ result: String)
    {
        if result.count < size {
            callback.update(result)
        }
    }
}

public class EqualToFilter : WordListCallback {
    private let callback : WordListCallback
    private let size : Int
    
    public init(callback : WordListCallback, size : Int){
        self.callback = callback
        self.size = size
    }
    public func update(_ result: String)
    {
        if result.count == size {
            callback.update(result)
        }
    }
}

public class StartsWithFilter : WordListCallback {
    private let callback : WordListCallback
    private let letters : String
    
    public init(callback : WordListCallback, letters : String){
        self.callback = callback
        self.letters = letters
    }
    public func update(_ result: String)
    {
        if result.hasPrefix(letters) {
            callback.update(result)
        }
    }
}

public class EndsWithFilter : WordListCallback {
    private let callback : WordListCallback
    private let letters : String
    
    public init(callback : WordListCallback, letters : String){
        self.callback = callback
        self.letters = letters
    }
    public func update(_ result: String)
    {
        if result.hasSuffix(letters) {
            callback.update(result)
        }
    }
}

public class ContainsFilter : WordListCallback {
    private let callback : WordListCallback
    private let letterSet : LetterSet
    
    public init(callback : WordListCallback, letters : String){
        self.callback = callback
        self.letterSet = LetterSet(word: letters)
    }
    public func update(_ result: String)
    {
        if (letterSet.isSupergram(result))
        {
            //contains all letters
            callback.update(result)
        }
    }
}
public class ExcludesFilter : WordListCallback {
    private let callback : WordListCallback
    private let letters : String
    
    public init(callback : WordListCallback, letters : String){
        self.callback = callback
        self.letters = letters
    }
    public func update(_ result: String)
    {
        for c in letters.unicodeScalars {
            if result.unicodeScalars.contains(c){
                //excluded letter found
                return
            }
        }
        //does not contain any of the excluded letters
        callback.update(result)
    }
}
public class ContainsWordFilter : WordListCallback {
    private let callback : WordListCallback
    private let word : String
    public init(callback : WordListCallback, word : String){
        self.callback = callback
        self.word = word
    }
    public func update(_ result: String)
    {
        if result.contains(word){
            callback.update(result)
        }
    }
}
public class ExcludesWordFilter : WordListCallback {
    private let callback : WordListCallback
    private let word : String
    public init(callback : WordListCallback, word : String){
        self.callback = callback
        self.word = word
    }
    public func update(_ result: String)
    {
        if !result.contains(word){
            callback.update(result)
        }
    }
}

public class RegexFilter : WordListCallback {
    private let callback : WordListCallback
    private let regex : NSRegularExpression?

    public init(callback : WordListCallback, pattern : String){
        self.callback = callback
        //need to append word boundaries \b otherwise regex will not match the words in the wordlist
        //Oddly units will pass without \b, why?
        regex = try? NSRegularExpression(pattern: "\\b"+pattern+"\\b", options: [])
    }
    public func update(_ result: String)
    {
        let range = NSRange(location: 0, length: result.length)
        if 1 == regex?.numberOfMatches(in: result, options: [], range: range){
            callback.update(result)
        }
    }
    public class func createCrosswordFilter(callback : WordListCallback, query : String) -> WordListCallback {
        let pattern = query
            .replace(".", withString: "[a-z]")
            .replace("@", withString: "[a-z]+")
        return RegexFilter(callback: callback, pattern: pattern)
    }
}

public class DistinctFilter : WordListCallback {
    private let callback : WordListCallback
    private let letterSet : LetterSet

    public init(callback : WordListCallback){
        self.callback = callback
        self.letterSet = LetterSet(word: "")
    }
    public func update(_ result: String) {
        letterSet.clear()
        letterSet.add(result)
        if letterSet.isDistinct() {
            callback.update(result)
        }
    }
}
