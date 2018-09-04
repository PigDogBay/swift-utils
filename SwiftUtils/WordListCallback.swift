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

open class WordListFilterWrapper : WordListCallback
{
    //should callback be weak?
    fileprivate let callback : WordListCallback!
    fileprivate var matches: [String] = []
    
    public init(callback: WordListCallback)
    {
        self.callback = callback
    }
    open func update(_ result: String)
    {
        if (!matches.contains(result))
        {
            matches.append(result)
            callback.update(result)
        }
    }
}


open class WordListMissingLetterWrapper : WordListCallback
{
    fileprivate let callback : WordListCallback!
    fileprivate let originalWord : String!
    
    public init(callback: WordListCallback, originalWord: String)
    {
        self.callback = callback
        self.originalWord = originalWord
    }
    
    open func update(_ result: String)
    {
        let missingLetters = originalWord.subtractLetters(result)
        callback.update("\(result) (\(missingLetters))")
    }
}

open class BiggerThanFilter : WordListCallback {
    fileprivate let callback : WordListCallback
    fileprivate let size : Int
    
    public init(callback : WordListCallback, size : Int){
        self.callback = callback
        self.size = size
    }
    open func update(_ result: String)
    {
        if result.count > size {
            callback.update(result)
        }
    }
}

open class LessThanFilter : WordListCallback {
    fileprivate let callback : WordListCallback
    fileprivate let size : Int
    
    public init(callback : WordListCallback, size : Int){
        self.callback = callback
        self.size = size
    }
    open func update(_ result: String)
    {
        if result.count < size {
            callback.update(result)
        }
    }
}

open class EqualToFilter : WordListCallback {
    fileprivate let callback : WordListCallback
    fileprivate let size : Int
    
    public init(callback : WordListCallback, size : Int){
        self.callback = callback
        self.size = size
    }
    open func update(_ result: String)
    {
        if result.count == size {
            callback.update(result)
        }
    }
}

open class StartsWithFilter : WordListCallback {
    fileprivate let callback : WordListCallback
    fileprivate let letters : String
    
    public init(callback : WordListCallback, letters : String){
        self.callback = callback
        self.letters = letters
    }
    open func update(_ result: String)
    {
        if result.hasPrefix(letters) {
            callback.update(result)
        }
    }
}

open class EndsWithFilter : WordListCallback {
    fileprivate let callback : WordListCallback
    fileprivate let letters : String
    
    public init(callback : WordListCallback, letters : String){
        self.callback = callback
        self.letters = letters
    }
    open func update(_ result: String)
    {
        if result.hasSuffix(letters) {
            callback.update(result)
        }
    }
}

open class ContainsFilter : WordListCallback {
    fileprivate let callback : WordListCallback
    fileprivate let letterSet : LetterSet
    
    public init(callback : WordListCallback, letters : String){
        self.callback = callback
        self.letterSet = LetterSet(word: letters)
    }
    open func update(_ result: String)
    {
        if (letterSet.isSupergram(result))
        {
            //contains all letters
            callback.update(result)
        }
    }
}
open class ExcludesFilter : WordListCallback {
    fileprivate let callback : WordListCallback
    fileprivate let letters : String
    
    public init(callback : WordListCallback, letters : String){
        self.callback = callback
        self.letters = letters
    }
    open func update(_ result: String)
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
open class ContainsWordFilter : WordListCallback {
    fileprivate let callback : WordListCallback
    fileprivate let word : String
    public init(callback : WordListCallback, word : String){
        self.callback = callback
        self.word = word
    }
    open func update(_ result: String)
    {
        if result.contains(word){
            callback.update(result)
        }
    }
}
open class ExcludesWordFilter : WordListCallback {
    fileprivate let callback : WordListCallback
    fileprivate let word : String
    public init(callback : WordListCallback, word : String){
        self.callback = callback
        self.word = word
    }
    open func update(_ result: String)
    {
        if !result.contains(word){
            callback.update(result)
        }
    }
}

open class RegexFilter : WordListCallback {
    fileprivate let callback : WordListCallback
    fileprivate let regex : NSRegularExpression?

    public init(callback : WordListCallback, pattern : String){
        self.callback = callback
        regex = try? NSRegularExpression(pattern: pattern, options: [])
    }
    open func update(_ result: String)
    {
        let range = NSRange(location: 0, length: result.length)
        if 1 == regex?.numberOfMatches(in: result, options: [], range: range){
            callback.update(result)
        }
    }
    open class func createCrosswordFilter(callback : WordListCallback, query : String) -> WordListCallback {
        let pattern = "\\b"+query
            .replace(".", withString: "[a-z]")
            .replace("@", withString: "[a-z]+")+"\\b"
        return RegexFilter(callback: callback, pattern: pattern)
    }
}


















