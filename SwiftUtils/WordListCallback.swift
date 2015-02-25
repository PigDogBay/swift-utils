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
    func update(result: String)
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
    public func update(result: String)
    {
        if (!contains(matches, result))
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
    
    public func update(result: String)
    {
        let missingLetters = originalWord.subtractLetters(result)
        callback.update("\(result) (\(missingLetters))")
    }
}
