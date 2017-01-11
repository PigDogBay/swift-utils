//
//  MissingLetters.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 09/01/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import Foundation

///  When doing anagram searches with blank letters, this class will help to highlight the letters in matching words that were
///  used for the blank letters.
open class MissingLetters
{
    let BUFFER_SIZE = 64
    //No fixed sized arrays in Swift, closest is
    //var buffer = [Int?](repeating: nil, count: 64)
    fileprivate var buffer : [UInt32] = [0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,
                                         0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0]
    
    fileprivate var positions : [Int] = [0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,
                                         0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0]
    fileprivate let lettersLen : Int
    fileprivate let letters : String
    fileprivate var builder  = ""
    
    /// Initialize class with anagram letters
    ///
    /// - Parameter letters: letters of the anagram not including blanks
    public init(letters: String){
        self.letters = letters
        self.lettersLen = letters.unicodeScalars.count
    }
    
    
    /// Find the position of a missing letter in the word used in findPositions
    ///
    /// - Parameter index: index into array of letter positions
    /// - Returns: letter position in the word
    public func getPositionAt(index : Int) -> Int {
        return positions[index]
    }
    
    /// Finds a letter in the buffer
    ///
    /// - Parameter letter: letter to be found
    /// - Returns: position in the buffer or -1 if not found
    fileprivate func findLetter(_ letter : UInt32) -> Int {
        //search upto length of the anagram letters
        for i in 0..<lettersLen {
            if buffer[i] == letter {
                return i
            }
        }
        return -1
    }
    
    /// Missing letters = word letters - anagram letters
    /// call getPositionAt() to access the positions of the letters in word
    ///
    /// - Parameter word: to find missing letters
    /// - Returns: number of missing letters found
    public func findPositions(word: String) -> Int {
        var index = 0
        //copy letters  into buffer
        for c in letters.unicodeScalars {
            buffer[index] = c.value
            index = index + 1
        }
        
        //use index as count for the positions found
        index = 0
        var indexInWord = 0;
        for c in word.unicodeScalars {
            //find letter in the buffer
            let pos = findLetter(c.value)
            if -1 == pos {
                //letter not found, therefore must be a blank letter
                positions[index] = indexInWord
                index = index + 1
            } else {
                //remove char to stop it being found again
                buffer[pos] = 0
            }
            indexInWord = indexInWord + 1
            
        }
        
        return index
        
    }
    
}
