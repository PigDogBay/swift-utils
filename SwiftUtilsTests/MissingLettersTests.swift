//
//  MissingLettersTests.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 09/01/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import XCTest
import SwiftUtils

class MissingLettersTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFindPosition1() {
        let target = MissingLetters(letters: "gaim")
        let actual = target.findPositions(word: "magic")
        XCTAssertEqual(actual, 1)
        XCTAssertEqual(target.getPositionAt(index: 0), 4)
    }

    func testFindPosition2() {
        let target = MissingLetters(letters: "aage")
        let actual = target.findPositions(word: "babbage")
        XCTAssertEqual(actual, 3)
        XCTAssertEqual(target.getPositionAt(index: 0), 0)
        XCTAssertEqual(target.getPositionAt(index: 1), 2)
        XCTAssertEqual(target.getPositionAt(index: 2), 3)
    }
    
    func testFindPosition3() {
        let target = MissingLetters(letters: "cigam")
        let actual = target.findPositions(word: "magic")
        XCTAssertEqual(actual, 0)
    }
    
    func testFindPosition4() {
        let target = MissingLetters(letters: "")
        let actual = target.findPositions(word: "magic")
        XCTAssertEqual(actual, 5)
        XCTAssertEqual(target.getPositionAt(index: 0), 0)
        XCTAssertEqual(target.getPositionAt(index: 2), 2)
        XCTAssertEqual(target.getPositionAt(index: 4), 4)
    }
    
    func testFindPosition5() {
        let target = MissingLetters(letters: "magic")
        let actual = target.findPositions(word: "")
        XCTAssertEqual(actual, 0)
    }

    func testFindPosition6() {
        let target = MissingLetters(letters: "magic")
        let actual = target.findPositions(word: "cog")
        XCTAssertEqual(actual, 1)
        XCTAssertEqual(target.getPositionAt(index: 0), 1)
    }
    
    func testFindPosition7() {
        let target = MissingLetters(letters: "kayleigh")
        let actual = target.findPositions(word: "breathtakingly")
        XCTAssertEqual(actual, 6)
        XCTAssertEqual(target.getPositionAt(index: 0), 0)
        XCTAssertEqual(target.getPositionAt(index: 1), 1)
        XCTAssertEqual(target.getPositionAt(index: 2), 4)
        XCTAssertEqual(target.getPositionAt(index: 3), 6)
        XCTAssertEqual(target.getPositionAt(index: 4), 7)
        XCTAssertEqual(target.getPositionAt(index: 5), 10)
    }
    
    func testFindPosition8() {
        let target = MissingLetters(letters: "holly")
        let actual = target.findPositions(word: "llanfairpwllgwyngyllgogeryqjxzchwyrndrobwllllantysiliogogogoch")
        XCTAssertEqual(actual, 57)
        XCTAssertEqual(target.getPositionAt(index: 0), 2)
    }

    func testPerformanceExample() {
        let target = MissingLetters(letters: "wonderba")
        self.measure {
            for _ in 0 ..< 1000
            {
                // Put the code you want to measure the time of here.
                _ = target.findPositions(word: "wonderful")
            }
        }
    }
    
}
