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
        return builder
    }
    
}
