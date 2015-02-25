//
//  StringUtilsTests.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 09/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import XCTest
import SwiftUtils

class StringUtilsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testContains1() {
        let actual = "m.gic".mpdb_contains(".")
        XCTAssert(actual, "Expect true")
    }
    func testContains2() {
        let actual = "#ace".mpdb_contains(".")
        XCTAssertFalse(actual, "Expect false")
    }
    func testGetSubWords1() {
        let actual = "motor".getSubWords()
        XCTAssert(actual.count==4,"count")
        XCTAssertEqual(actual[0], "oort", "0")
        XCTAssertEqual(actual[1], "mort", "1")
        XCTAssertEqual(actual[2], "moot", "2")
        XCTAssertEqual(actual[3], "moor", "3")
    }
    func testGetSubWords2() {
        let actual = "".getSubWords()
        XCTAssert(actual.count==0,"count")
    }
    //Recursive version of the function
    func testGetSubWords3() {
        let actual = "abcdefghi".getSubWords(6)
        //9     8-letter-words
        //9*8   7-letter-words
        //9*8*7 6-letter-words
        XCTAssertEqual(actual.count,9*8*7 + 9*8 + 9,"count")
        XCTAssert(contains(actual, "bcdefghi"), "1")
        XCTAssert(contains(actual, "bcdeghi"), "2")
        XCTAssert(contains(actual, "bcdegh"), "3")
        XCTAssert(!contains(actual, "bcdeg"), "4")
    }
    
    func testSubtractLetters1()
    {
        var actual = "abcdefghi".subtractLetters("agi")
        XCTAssertEqual(actual, "bcdefh")

        actual = "abcdefghi".subtractLetters("jkl")
        XCTAssertEqual(actual, "abcdefghi")

        actual = "abcdefghi".subtractLetters("abc")
        XCTAssertEqual(actual, "defghi")

        actual = "abcdefghi".subtractLetters("ghi")
        XCTAssertEqual(actual, "abcdef")

        actual = "abcdefghi".subtractLetters("abcdefghi")
        XCTAssertEqual(actual, "")
    }
    func testSubtractLetters2()
    {
        var actual = "abba".subtractLetters("ab")
        XCTAssertEqual(actual, "ba")
        
        actual = "abba".subtractLetters("aa")
        XCTAssertEqual(actual, "bb")

        actual = "abba".subtractLetters("bb")
        XCTAssertEqual(actual, "aa")
        
    }
    //Check self is not modified
    func testSubtractLetters3()
    {
        var target = "do not modify"
        var actual = target.subtractLetters("do ")
        XCTAssertEqual(actual, "not modify")
        XCTAssertEqual(target, "do not modify")
    }
    
    func testDoesNotContainBannedLetters()
    {
        var actual = "abcdefghi".doesNotContainBannedLetters(Array("jkl"))
        XCTAssert(actual)
        actual = "abcdefghi".doesNotContainBannedLetters(Array("abc"))
        XCTAssert(!actual)
        actual = "abcdefghi".doesNotContainBannedLetters(Array("ijk"))
        XCTAssert(!actual)
        actual = "abcdefghi".doesNotContainBannedLetters(Array("a"))
        XCTAssert(!actual)
        actual = "abcdefghi".doesNotContainBannedLetters(Array("i"))
        XCTAssert(!actual)
        actual = "abcdefghi".doesNotContainBannedLetters(Array("d"))
        XCTAssert(!actual)
        actual = "abcdefghi".doesNotContainBannedLetters(Array("z"))
        XCTAssert(actual)
    }

}
