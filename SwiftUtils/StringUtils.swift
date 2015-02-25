//
//  StringUtils.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 09/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import Foundation

public extension String
{
    
    public func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    //return the string in specified range
    public subscript (r: Range<Int>) -> String
    {
        let startIndex = advance(self.startIndex, r.startIndex)
        let endIndex = advance(startIndex, r.endIndex - r.startIndex)
        return self[Range(start: startIndex, end: endIndex)]
    }
    
    public func mpdb_contains(s : String) -> Bool
    {
        return self.rangeOfString(s) != nil
    }
    
    /*
        Returns all the words that are one letter less, 
        eg ABCD returns
        BCD, ACD, ABD, ABC
    */
    public func getSubWords() ->[String]
    {
        //sort letter into a Array[Character]
        let sortedLetters = sorted(self,<)
        let len = sortedLetters.count
        var subwords = [String]()
        for var i=0 ; i<len; i++
        {
            //string builder to make the sub word
            var builder = ""
            //copy the sortedLetters string but
            //skip the letter at index i
            for var j=0 ; j<len ; j++
            {
                if (i != j)
                {
                    builder.append(sortedLetters[j])
                }
            }
            //don't add words already found
            if !contains(subwords,builder)
            {
                subwords.append(builder)
            }
        }
        return subwords
    }
    /*
        Recursively find subwords
    
        If the string is 9 letters and min length is 6, will generate
        9 eight letter words
        9*8 seven letter words
        9*8*7 six letter words
    */
    public func getSubWords(minLength: Int) -> [String]
    {
        var aggregate = [String]()
        let len = self.utf16Count
        if len>minLength
        {
            let parentList = self.getSubWords()
            aggregate.extend(parentList)
            for subword in parentList
            {
                aggregate.extend(subword.getSubWords(minLength))
            }
        }
        return aggregate
    }
    /*
        Subtracts the letters of word from the string
    */
    public func subtractLetters(word : String) ->String
    {
        var builder = Array(self)
        for delChar in word
        {
            let len = builder.count
            for var i=0; i<len; i++
            {
                if delChar == builder[i]
                {
                    builder.removeAtIndex(i)
                    break;
                }
            }
        }
        return String(builder)
    }
    
    public func doesNotContainBannedLetters(bannedLetters: [Character]) -> Bool
    {
        let chars = Array(self)
        for c in bannedLetters
        {
            if contains(chars, c)
            {
                return false
            }
        }
        return true
        
    }
    
}