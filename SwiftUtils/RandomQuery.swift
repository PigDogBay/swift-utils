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
    let examples = ["m?g??","moonstarer","z9","james-bond","scrabb++","kayleigh*","super@ted","..112332"]
    
    
    public init(){
        
    }
    
    public func anagram() -> String {
        let v = Int.random(in: 1...5)
        let c = Int.random(in: 2...10)
        return anagram(numberOfVowels: v, numberOfConsonants: c)
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
    
    public func crossword() -> String {
        let l = Int.random(in: 1...5)
        let u = Int.random(in: 2...10)
        return crossword(numberOfLetters: l, numberOfUnknowns: u)
    }

    
    public func twoWords() -> String {
        var anag = anagram() + WordSearch.TWO_WORD_STR
        if anag.first == " " || anag.last == " " {
            anag = shuffle(ordered: anag)
        }
        return shuffle(ordered: anag)
    }
    
    public func supergram() -> String {
        return anagram() + WordSearch.SUPERGRAM_STR
    }

    public func blankLetters() -> String {
        let b = Int.random(in: 1...3)
        var builder = anagram()
        for _ in 1...b {
            builder = builder + WordSearch.BLANK_STR
        }
        return builder
    }
    
    public func prefixSuffix() -> String {
        let anag = anagram() + WordSearch.WILDCARD_STR
        return shuffle(ordered: anag)
    }

    public func wildcardCrossword() -> String {
        let anag = crossword() + WordSearch.WILDCARD_STR
        return shuffle(ordered: anag)
    }
    
    public func codeword()-> String {
        let r = Int.random(in: 1...3)
        var builder = anagram(numberOfVowels: 2, numberOfConsonants: 3) + "11.."
        if r > 2 {
            builder = builder + "33"
        }
        if r > 1 {
            builder = builder + "22"
        }
        return shuffle(ordered: builder)
    }

    public func example() -> String {
        return examples.randomElement()!
    }
    
    private func shuffle(ordered : String) -> String {
        var a = Array(ordered)
        a.shuffle()
        return String(a)
    }
    
}
