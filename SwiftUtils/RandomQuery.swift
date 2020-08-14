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
    let examples = ["m?g??","moonstarer","z9","james-bond","scrabb++","kayleigh*","super@ted","..112332", "r??p?????", "c??v?r","????ial","eprsu"
        , "manchester-united", "cli-ntea-stwood", "google++++", "stratus+", "sup@x?", "microsoft*", "?a???p??", "steam", "hearts", "@ace", "zslteram", "thidgof"
        , "m.z@", ".m.z.", "vegdances", "c....w...", "itchysemi", "w ackoanglo rocker", "*", "++++", "...", "@x@", "llan@", "British Broadcasting Corporation"]
    
    
    public init(){
    }
    
    public func query() -> String{
        let r = Int.random(in: 1...3)
        if r == 1 {
            return example()
        }

        let randomSearchType = SearchType.allCases.randomElement()!
        switch randomSearchType {
        case .crossword:
            return crossword()
        case .anagram:
            return anagram()
        case .twoWordAnagram:
            return twoWords()
        case .wildcard:
            return prefixSuffix()
        case .wildcardAndCrossword:
            return wildcardCrossword()
        case .blanks:
            return blankLetters()
        case .supergram:
            return supergram()
        case .codeword:
            return codeword()
        }
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
        let v = Int.random(in: 1...2)
        let c = Int.random(in: 1...4)
        let anag = anagram(numberOfVowels: v, numberOfConsonants: c) + WordSearch.WILDCARD_STR
        return shuffle(ordered: anag)
    }

    public func wildcardCrossword() -> String {
        let l = Int.random(in: 1...3)
        let u = Int.random(in: 1...3)
        let anag = crossword(numberOfLetters: l, numberOfUnknowns: u) + WordSearch.WILDCARD_STR
        return shuffle(ordered: anag)
    }
    
    public func codeword()-> String {
        let c = Int.random(in: 1...2)
        var builder = anagram(numberOfVowels: 1, numberOfConsonants: c) + "11.."

        let r = Int.random(in: 1...3)
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
