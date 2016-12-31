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
