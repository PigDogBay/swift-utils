//
//  LetterSet.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 11/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import Foundation

//Class to help compare letters in lower case words
open class LetterSet
{
    //buffers to hold a count of each letter, buffer[4] == count of the letter 'e'
    fileprivate var setA : [Int] = [0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0]
    fileprivate var setB : [Int] = [0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0]
    fileprivate let LOWEST_CHAR_VALUE = Int(UnicodeScalar("a").value)
    
    public init(word: String)
    {
        add(word)
    }
    
    open func clear()
    {
        for i in 0 ..< 26 
        {
            setA[i]=0
        }
    }
    
    open func add(_ word: String)
    {
        for s in word.unicodeScalars
        {
            let index = Int(s.value) - LOWEST_CHAR_VALUE
            if index>=0 && index<26{
                setA[index] += 1
            }
        }
    }
    open func delete(_ word: String)
    {
        for s in word.unicodeScalars
        {
            let index = Int(s.value) - LOWEST_CHAR_VALUE
            if index>=0 && index<26 {
                setA[index] -= 1
            }
        }
    }
    open func isValid()->Bool
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
        for s in letters.unicodeScalars
        {
            let index = Int(s.value) - LOWEST_CHAR_VALUE
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
    open func isAnagram(_ word: String) -> Bool
    {
        clearSetB()
        addToSetB(word)
        return isAIdenticalToB()
    }
    open func isAnagram(_ word: String, numberOfBlanks: Int) -> Bool
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
    open func isSupergram(_ word: String) -> Bool
    {
        clearSetB()
        addToSetB(word)
        return isASubsetOfB()
    }
    //is word a sub-anagram of the letters in set A
    open func isSubgram(_ word: String) -> Bool
    {
        clearSetB()
        addToSetB(word)
        return isASupersetOfB()
    }
    
    open func getCount(scalar : UnicodeScalar) -> Int {
        let index = Int(scalar.value) - LOWEST_CHAR_VALUE
        if index>=0 && index<26 {
            return setA[index]
        }
        return 0
    }
}
