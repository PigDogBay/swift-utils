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
    fileprivate var setA : [Int] = [0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0]
    fileprivate var setB : [Int] = [0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0]
    fileprivate let LOWEST_CHAR_VALUE = Int(UnicodeScalar("a").value)
    
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
    
    public func add(_ word: String)
    {
        for s in word.utf8
        {
            let index = Int(s) - LOWEST_CHAR_VALUE
            if index>=0 && index<26{
                setA[index] += 1
            }
        }
    }
    public func delete(_ word: String)
    {
        for s in word.utf8
        {
            let index = Int(s) - LOWEST_CHAR_VALUE
            if index>=0 && index<26 {
                setA[index] -= 1
            }
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

    fileprivate func clearSetB()
    {
        for i in 0 ..< 26
        {
            setB[i]=0
        }
    }
    

    fileprivate func addToSetB(_ letters: String)
    {
        for s in letters.utf8
        {
            let index = Int(s) - LOWEST_CHAR_VALUE
            if index>=0 && index<26 {
                setB[index] += 1
            }
        }
    }
    
    fileprivate func isASupersetOfB()->Bool
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
    fileprivate func isASubsetOfB()->Bool
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
    fileprivate func isAIdenticalToB()->Bool
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
    public func isAnagram(_ word: String) -> Bool
    {
        clearSetB()
        addToSetB(word)
        return isAIdenticalToB()
    }
    public func isAnagram(_ word: String, numberOfBlanks: Int) -> Bool
    {
        clearSetB()
        addToSetB(word)
        for i in 0 ..< 26
        {
            setB[i] = setB[i] - setA[i]
            if setB[i] < 0 { setB[i]=0}
        }
        let count = setB.reduce(0, +)
        return count <= numberOfBlanks
    }
    
    //is word a super-anagram of the letters in set A
    public func isSupergram(_ word: String) -> Bool
    {
        clearSetB()
        addToSetB(word)
        return isASubsetOfB()
    }
    //is word a sub-anagram of the letters in set A
    public func isSubgram(_ word: String) -> Bool
    {
        clearSetB()
        addToSetB(word)
        return isASupersetOfB()
    }
    
    //only contains 1 or 0 of each letter
    public func isDistinct() -> Bool {
        var count = 0
        for i in 0..<26 {
            let numLetters = setA[i]
            if numLetters>1 {return false}
            count = count + numLetters
        }
        return count>0
    }
    
    public func getCount(scalar : UnicodeScalar) -> Int {
        let index = Int(scalar.value) - LOWEST_CHAR_VALUE
        if index>=0 && index<26 {
            return setA[index]
        }
        return 0
    }
}
