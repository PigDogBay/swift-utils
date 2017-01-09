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
        XCTAssert(actual.contains("bcdefghi"), "1")
        XCTAssert(actual.contains("bcdeghi"), "2")
        XCTAssert(actual.contains("bcdegh"), "3")
        XCTAssert(!actual.contains("bcdeg"), "4")
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
        let target = "do not modify"
        let actual = target.subtractLetters("do ")
        XCTAssertEqual(actual, "not modify")
        XCTAssertEqual(target, "do not modify")
    }
    
    func testDoesNotContainBannedLetters()
    {
        var actual = "abcdefghi".doesNotContainBannedLetters(["j","k","l"])
        XCTAssert(actual)
        actual = "abcdefghi".doesNotContainBannedLetters(["a","b","c"])
        XCTAssert(!actual)
        actual = "abcdefghi".doesNotContainBannedLetters(["i","j","k"])
        XCTAssert(!actual)
        actual = "abcdefghi".doesNotContainBannedLetters(["a"])
        XCTAssert(!actual)
        actual = "abcdefghi".doesNotContainBannedLetters(["i"])
        XCTAssert(!actual)
        actual = "abcdefghi".doesNotContainBannedLetters(["d"])
        XCTAssert(!actual)
        actual = "abcdefghi".doesNotContainBannedLetters(["z"])
        XCTAssert(actual)
    }
    
    //
    //0.193 0.192 0.196 unicodeScalars.count
    //0.308 0.315 0.312 utf16.count
    //0.465 0.461 0.465 characters.count
    func testPerformanceLength() {
        // This is an example of a performance test case.
        let target = "wonderba"
        self.measure {
            for _ in 0 ..< 1000000
            {
                target.length
            }
        }
    }
    
    func testSubstringSubscipt() {
        let target = "Holly Bailey"
        XCTAssertEqual(target[0..<5],"Holly")
        XCTAssertEqual(target[3..<7],"ly B")
        XCTAssertEqual(target[6..<12],"Bailey")
    }

}
