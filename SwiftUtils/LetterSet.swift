//
//  LetterSet.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 11/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import Foundation

//Class to help compare letters in lower case words
public class LetterSet
{
    //buffers to hold a count of each letter, buffer[4] == count of the letter 'e'
    private var setA : [Int] = [0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0]
    private var setB : [Int] = [0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0]
    private let LOWEST_CHAR_VALUE = Int(UnicodeScalar("a").value)
    
    public init(word: String)
    {
        add(word)
    }
    
    public func clear()
    {
        for i in 0 ..< 26 
        {
            setA[i]=0
        }
    }
    
    public func add(word: String)
    {
        for s in word.unicodeScalars
        {
            let index = Int(s.value) - LOWEST_CHAR_VALUE
            setA[index] += 1
        }
    }
    public func delete(word: String)
    {
        for s in word.unicodeScalars
        {
            let index = Int(s.value) - LOWEST_CHAR_VALUE
            setA[index] -= 1
        }
    }
    public func isValid()->Bool
    {
        for i in 0 ..< 26
        {
            if setA[i]<0
            {
                return false
            }
        }
        return true
    }

    private func clearSetB()
    {
        for i in 0 ..< 26
        {
            setB[i]=0
        }
    }
    

    private func addToSetB(letters: String)
    {
        for s in letters.unicodeScalars
        {
            let index = Int(s.value) - LOWEST_CHAR_VALUE
            setB[index] += 1
        }
    }
    
    private func isASupersetOfB()->Bool
    {
        for i in 0 ..< 26
        {
            if setB[i] > setA[i]
            {
                return false
            }
        }
        return true;
    }
    private func isASubsetOfB()->Bool
    {
        for i in 0 ..< 26
        {
            if setA[i] > setB[i]
            {
                return false
            }
        }
        return true;
    }
    private func isAIdenticalToB()->Bool
    {
        for i in 0 ..< 26
        {
            if setA[i] != setB[i]
            {
                return false
            }
        }
        return true;
    }
    public func isAnagram(word: String) -> Bool
    {
        clearSetB()
        addToSetB(word)
        return isAIdenticalToB()
    }
    
    //is word a super-anagram of the letters in set A
    public func isSupergram(word: String) -> Bool
    {
        clearSetB()
        addToSetB(word)
        return isASubsetOfB()
    }
    //is word a sub-anagram of the letters in set A
    public func isSubgram(word: String) -> Bool
    {
        clearSetB()
        addToSetB(word)
        return isASupersetOfB()
    }
    
}