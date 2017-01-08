//
//  LetterSetTests.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 11/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import XCTest
import SwiftUtils

class LetterSetTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsAnagramBlank1(){
        let target = LetterSet(word: "cat")
        XCTAssert(target.isAnagram("chart", numberOfBlanks: 3))
        XCTAssert(target.isAnagram("charts", numberOfBlanks: 3))
        XCTAssertFalse(target.isAnagram("charted", numberOfBlanks: 3))
    }
    func testIsAnagramBlank2(){
        let target = LetterSet(word: "")
        XCTAssert(target.isAnagram("", numberOfBlanks: 0))
        XCTAssert(target.isAnagram("cat", numberOfBlanks: 3))
        XCTAssertFalse(target.isAnagram("cats", numberOfBlanks: 3))
    }
    func testIsAnagramBlank3(){
        let target = LetterSet(word: "black")
        XCTAssert(target.isAnagram("black", numberOfBlanks: 0))
        XCTAssertFalse(target.isAnagram("clack", numberOfBlanks: 0))
        XCTAssert(target.isAnagram("clack", numberOfBlanks: 1))
    }

    func testIsAnagram1() {
        let target = LetterSet(word: "hearts")
        XCTAssert(target.isAnagram("earths"))
        XCTAssertFalse(target.isAnagram("eatths"))
    }
    func testIsAnagram2() {
        let target = LetterSet(word: "streamline")
        XCTAssert(target.isAnagram("linestream"))
        XCTAssertFalse(target.isAnagram("linestmeer"))
    }
    func testIsSupergram1() {
        let target = LetterSet(word: "err")
        XCTAssert(target.isSupergram("supergram"))
    }
    func testIsSupergram2() {
        let target = LetterSet(word: "supergram")
        XCTAssert(target.isSupergram("supergram"))
    }
    func testIsSupergram3() {
        let target = LetterSet(word: "eri")
        XCTAssertFalse(target.isSupergram("supergram"))
    }
    func testIsSupergram4() {
        let alphabet="abcdefghijklmnopqrstuvwxyz"
        let target = LetterSet(word: alphabet)
        XCTAssert(target.isSupergram(alphabet))
    }
    func testIsSubgram1()
    {
        let target = LetterSet(word: "streamline")
        XCTAssert(target.isSubgram("treenails"))
        XCTAssert(target.isSubgram("steamier"))
        XCTAssert(target.isSubgram("merlins"))
        XCTAssertFalse(target.isSubgram("reamx"))
    }
    func testIsSubgram2()
    {
        let target = LetterSet(word: "hearts")
        XCTAssert(target.isSubgram("rates"))
        XCTAssertFalse(target.isSubgram("ratjs"))
        XCTAssert(target.isSubgram("shat"))
        XCTAssertFalse(target.isSubgram("shit"))
        XCTAssert(target.isSubgram("eat"))
        XCTAssertFalse(target.isSubgram("emt"))
        
    }
    let loop = 1
    func testPerformanceIsAnagram() {
        let target = LetterSet(word: "streamline")
        // This is an example of a performance test case.
        self.measure() {
            for _ in 0 ..< self.loop
            {
                target.isAnagram("linestream")
                target.isAnagram("linestream")
                target.isAnagram("linestream")
                target.isAnagram("linestream")
                if !target.isAnagram("linestream")
                {
                    break
                }
            }
        }
    }
    func testPerformanceIsSupergram1() {
        let target = LetterSet(word:  "hearts")
        // This is an example of a performance test case.
        self.measure() {
            for _ in 0 ..< self.loop
            {
                target.isSupergram("breathers")
                target.isSupergram("breathers")
                target.isSupergram("breathers")
                target.isSupergram("breathers")
                if !target.isSupergram("breathers")
                {
                    break
                }
            }
        }
    }

}
