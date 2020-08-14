//
//  RandomQueryTests.swift
//  SwiftUtilsTests
//
//  Created by Mark Bailey on 14/08/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Foundation
import XCTest
import SwiftUtils

class RandomQueryTests: XCTestCase {
    let loop = 100
    let wordSearch = WordSearch(wordList: WordList())
    
    private func check(query : String, expectedType : SearchType){
        let preProcess = wordSearch.preProcessQuery(query)
        XCTAssertEqual(query,preProcess)
        let searchType = wordSearch.getQueryType(query)
        XCTAssertEqual(searchType, expectedType)
    }

    func testAnagram1(){
        let randomQuery = RandomQuery()
        for _ in 1...loop {
            let actual = randomQuery.anagram(numberOfVowels: 3, numberOfConsonants: 6)
            XCTAssertEqual(actual.length, 9)
            check(query: actual, expectedType: .anagram)
        }
    }

    func testAnagram2(){
        let randomQuery = RandomQuery()
        for _ in 1...loop {
            let actual = randomQuery.anagram()
            check(query: actual, expectedType: .anagram)
        }
    }

    func testCrossword1(){
        let randomQuery = RandomQuery()
        for _ in 1...loop {
            let actual = randomQuery.crossword(numberOfLetters: 3, numberOfUnknowns: 6)
            XCTAssertEqual(actual.length, 9)
            check(query: actual, expectedType: .crossword)
        }
    }
    
    func testCrossword2(){
        let randomQuery = RandomQuery()
        for _ in 1...loop {
            let actual = randomQuery.crossword()
            check(query: actual, expectedType: .crossword)
        }
    }

    func testTwoWords1(){
        let randomQuery = RandomQuery()
        for _ in 1...loop {
            let actual = randomQuery.twoWords()
            check(query: actual, expectedType: .twoWordAnagram)
        }
    }

}
