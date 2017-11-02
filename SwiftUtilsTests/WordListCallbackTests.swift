//
//  WordListCallbackTests.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 09/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import XCTest
import SwiftUtils

class WordListCallbackTests: XCTestCase, WordListCallback  {

    var result: String?
    func update(_ result: String) {
        self.result = result
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        result = nil
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFilterWrapper() {
        // This is an example of a functional test case.
        let target = WordListFilterWrapper(callback: self)
        target.update("unique")
        XCTAssertEqual(result!, "unique")
        result = nil
        target.update("only")
        XCTAssertEqual(result!, "only")
        result = nil
        target.update("unique")
        XCTAssert(result==nil)
        
    }
    
    func testMissingLettersWrapper()
    {
        let target = WordListMissingLetterWrapper(callback: self, originalWord: "abcdefghi")
        target.update("abcdef")
        XCTAssertEqual(result!, "abcdef (ghi)")

        target.update("defghi")
        XCTAssertEqual(result!, "defghi (abc)")
    }

    func testBiggerThanFilter1()
    {
        let target = BiggerThanFilter(callback: self, size: 5)
        target.update("abcdef")
        XCTAssertEqual(result!, "abcdef")
    }
    func testBiggerThanFilter2()
    {
        let target = BiggerThanFilter(callback: self, size: 5)
        target.update("abcde")
        XCTAssertNil(result)
    }
    func testLessThanFilter1()
    {
        let target = LessThanFilter(callback: self, size: 7)
        target.update("abcdef")
        XCTAssertEqual(result!, "abcdef")
    }
    func testLessThanFilter2()
    {
        let target = LessThanFilter(callback: self, size: 6)
        target.update("abcdef")
        XCTAssertNil(result)
    }
    func testEqualToFilter1()
    {
        let target = EqualToFilter(callback: self, size: 6)
        target.update("abcdef")
        XCTAssertEqual(result!, "abcdef")
    }
    func testEqualToFilter2()
    {
        let target = EqualToFilter(callback: self, size: 5)
        target.update("abcdef")
        XCTAssertNil(result)
    }
    func testStartsWithFilter1()
    {
        let target = StartsWithFilter(callback: self, letters: "abc")
        target.update("abcdef")
        XCTAssertEqual(result!, "abcdef")
    }
    func testStartsWithFilter2()
    {
        let target = StartsWithFilter(callback: self, letters: "def")
        target.update("abcdef")
        XCTAssertNil(result)
    }
    func testEndsWithFilter1()
    {
        let target = EndsWithFilter(callback: self, letters: "def")
        target.update("abcdef")
        XCTAssertEqual(result!, "abcdef")
    }
    func testEndsWithFilter2()
    {
        let target = EndsWithFilter(callback: self, letters: "abc")
        target.update("abcdef")
        XCTAssertNil(result)
    }
    func testContainsFilter1()
    {
        let target = ContainsFilter(callback: self, letters: "ace")
        target.update("abcdef")
        XCTAssertEqual(result!, "abcdef")
    }
    func testContainsFilter2()
    {
        let target = ContainsFilter(callback: self, letters: "axe")
        target.update("abcdef")
        XCTAssertNil(result)
    }
    func testExcludesFilter1()
    {
        let target = ExcludesFilter(callback: self, letters: "mno")
        target.update("abcdef")
        XCTAssertEqual(result!, "abcdef")
    }
    func testExcludesFilter2()
    {
        let target = ExcludesFilter(callback: self, letters: "fgh")
        target.update("abcdef")
        XCTAssertNil(result)
    }

}
