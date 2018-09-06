//
//  CodewordSolver.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 06/09/2018.
//  Copyright © 2018 MPD Bailey Technology. All rights reserved.
//

import Foundation

open class CodewordSolver {
    fileprivate let CROSSWORD_CHAR = UnicodeScalar(".")
    fileprivate let SAME_CHAR_1 = UnicodeScalar("1")
    fileprivate let SAME_CHAR_2 = UnicodeScalar("2")
    fileprivate let SAME_CHAR_3 = UnicodeScalar("3")
    fileprivate let SAME_CHAR_4 = UnicodeScalar("4")
    fileprivate let SAME_CHAR_5 = UnicodeScalar("5")
    fileprivate let SAME_CHAR_6 = UnicodeScalar("6")
    fileprivate let SAME_CHAR_7 = UnicodeScalar("7")
    
    class Letter {
        var character : UnicodeScalar
        let position : Int
        
        init(character : UnicodeScalar, position : Int){
            self.character = character
            self.position = position
        }
    }
    
    var unknowns : [Letter] = []
    var knowns : [Letter] = []
    var same1 : [Letter] = []
    var same2 : [Letter] = []
    var same3 : [Letter] = []
    var same4 : [Letter] = []
    var same5 : [Letter] = []
    var same6 : [Letter] = []
    var same7 : [Letter] = []
    
    var letterSet = LetterSet(word: "")
    fileprivate var wordLength = 0
    
    public init(){}
    
    open func parse(query : String){
        unknowns.removeAll()
        knowns.removeAll()
        same1.removeAll()
        same2.removeAll()
        same3.removeAll()
        same4.removeAll()
        same5.removeAll()
        same6.removeAll()
        same7.removeAll()
        
        wordLength = query.length
        var pos = 0
        for s in query.unicodeScalars {
            let letter = Letter(character: s,position: pos)
            pos = pos + 1

            switch s {
            case CROSSWORD_CHAR:
                unknowns.append(letter)
            case SAME_CHAR_1:
                same1.append(letter)
            case SAME_CHAR_2:
                same2.append(letter)
            case SAME_CHAR_3:
                same3.append(letter)
            case SAME_CHAR_4:
                same4.append(letter)
            case SAME_CHAR_5:
                same5.append(letter)
            case SAME_CHAR_6:
                same6.append(letter)
            case SAME_CHAR_7:
                same7.append(letter)
            default:
                knowns.append(letter)
            }
        }
    }
    
    open func isMatch(word : String) -> Bool {
        //check if known letters match
        let scalars = word.unicodeScalars
        for letter in knowns {
            let index = scalars.index(scalars.startIndex, offsetBy: letter.position)
            if letter.character != scalars[index] {return false}
        }
        //check if numbered letters are the same and different to the rest
        if !checkSameLetters(word: scalars, sameLetters: &same1) {return false}
        if !checkSameLetters(word: scalars, sameLetters: &same2) {return false}
        if !checkSameLetters(word: scalars, sameLetters: &same3) {return false}
        if !checkSameLetters(word: scalars, sameLetters: &same4) {return false}
        if !checkSameLetters(word: scalars, sameLetters: &same5) {return false}
        if !checkSameLetters(word: scalars, sameLetters: &same6) {return false}
        if !checkSameLetters(word: scalars, sameLetters: &same7) {return false}
        
        //check knowns do not equal unknown
        for unknown in unknowns {
            let index = scalars.index(scalars.startIndex, offsetBy: unknown.position)
            let c = scalars[index]
            if knowns.contains(where: {known in known.character == c}) {return false}
            //store char for later use
            unknown.character = c
        }
        
        //check no other groups of letters in the unknowns
        letterSet.clear()
        letterSet.add(word)
        if unknowns.contains(where: { letter in letterSet.getCount(scalar: letter.character) > 1}) {return false}

        return true
    }
    
    /*
     Check that the pattern of the same letters are actuall the same
    */
    fileprivate func checkSameLetters(word : String.UnicodeScalarView, sameLetters : inout [Letter]) -> Bool {
        if sameLetters.count<2 {return true}
        //get the letter that is the same
        let letterIndex = word.index(word.startIndex, offsetBy: sameLetters[0].position)
        let c = word[letterIndex]
        //check if numbered letters are the same
        for sl in sameLetters.dropFirst() {
            let index = word.index(word.startIndex, offsetBy: sl.position)
            if c != word[index] {return false}
        }
        //check that the other letters in the word are different
        var pos = 0
        for s in word {
            if !sameLetters.contains(where: {letter in letter.position == pos }) {
                if (s == c) {return false}
            }
            pos = pos + 1
        }
        return true
    }
}
