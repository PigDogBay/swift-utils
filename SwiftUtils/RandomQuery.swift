//
//  RandomQuery.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 14/08/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Foundation

public struct RandomQuery {
    let vowels = ["a","e","i","o","u"]
    let consonants = ["b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z"]
    let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    
    public init(){
        
    }
    public func anagram(numberOfVowels v: Int, numberOfConsonants c: Int) -> String {
        var builder = ""
        for _ in 1...v {
            builder = builder + vowels.randomElement()!
        }
        for _ in 1...c {
            builder = builder + consonants.randomElement()!
        }
        return shuffle(ordered: builder)
    }
    
    public func crossword(numberOfLetters l : Int, numberOfUnknowns u : Int) -> String{
        var builder = ""
        for _ in 1...l {
            builder = builder + letters.randomElement()!
        }
        for _ in 1...u {
            builder = builder + WordSearch.CROSSWORD_STR
        }
        return shuffle(ordered: builder)

    }
    
    private func shuffle(ordered : String) -> String {
        var a = Array(ordered)
        a.shuffle()
        return String(a)
    }
    
}
