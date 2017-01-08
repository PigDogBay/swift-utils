//
//  WordListTests.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 10/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import XCTest
import SwiftUtils

class WordListTests: XCTestCase, WordListCallback {
    let list = [
        "spectrum","commodore","oric","dragon","nextstep",
        "vale","evesham","vaio","acorn","electron",
        "amiga","atari","micro","eight","pectrums",
        "bit","murtpecs","sinclair","research","macbook"]
    
    let carList = ["celica","sierra","focus"]
    let fruitList = ["strawberry","banana","apple"]
    
    var matches: [String] = []
    
    func update(_ result: String) {
        matches.append(result)
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        matches.removeAll(keepingCapacity: false)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFindCrosswordsTest1() {
        
        let target = WordList(wordlist: list)
        target.findCrosswords("a....", callback: self)
        XCTAssert(3 == matches.count)
        XCTAssertEqual("acorn",matches[0])
        XCTAssertEqual("amiga",matches[1])
        XCTAssertEqual("atari",matches[2])
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAddNewWords1()
    {
        let target = WordList(wordlist: carList)
        target.addNewWords(fruitList)
        XCTAssert(6 == target.wordlist.count)
        XCTAssertEqual("strawberry",target.wordlist[0])
        XCTAssertEqual("banana",target.wordlist[1])
        XCTAssertEqual("celica",target.wordlist[2])
        XCTAssertEqual("sierra",target.wordlist[3])
        XCTAssertEqual("apple",target.wordlist[4])
        XCTAssertEqual("focus",target.wordlist[5])
    }
    
    func testFindAnagramsWithBlanks(){
        let target = WordList(wordlist: list)
        target.findAnagrams("aai", numberOfBlanks: 2, callback: self)
        XCTAssert(4 == matches.count)
        
    }

}
