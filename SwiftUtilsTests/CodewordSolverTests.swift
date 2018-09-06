//
//  CodewordSolverTests.swift
//  SwiftUtilsTests
//
//  Created by Mark Bailey on 06/09/2018.
//  Copyright © 2018 MPD Bailey Technology. All rights reserved.
//

import Foundation
import XCTest
import SwiftUtils

class CodewordSolverTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testKnownLetters1(){
        let codewordSolver = CodewordSolver()
        codewordSolver.parse(query: ".a.")
        XCTAssert(codewordSolver.isMatch(word: "cat"))
        XCTAssertFalse(codewordSolver.isMatch(word: "dog"))
    }
    
    func testKnownLetters2(){
        let codewordSolver = CodewordSolver()
        codewordSolver.parse(query: "p..i.e")
        XCTAssert(codewordSolver.isMatch(word: "praise"))
        XCTAssertFalse(codewordSolver.isMatch(word: "praist"))
        XCTAssertFalse(codewordSolver.isMatch(word: "xraise"))
        XCTAssertFalse(codewordSolver.isMatch(word: "prazse"))
    }
    //Known letters are different to unknown
    func testKnownLetters3(){
        let codewordSolver = CodewordSolver()
        codewordSolver.parse(query: "st...")
        XCTAssert(codewordSolver.isMatch(word: "stand"))
        XCTAssertFalse(codewordSolver.isMatch(word: "stats"))
        XCTAssertFalse(codewordSolver.isMatch(word: "stans"))
        XCTAssertFalse(codewordSolver.isMatch(word: "stint"))
    }

    //Multiple known letters
    func testKnownLetters4(){
        let codewordSolver = CodewordSolver()
        codewordSolver.parse(query: "aar..ar.")
        XCTAssert(codewordSolver.isMatch(word: "aardvark"))
    }

    func testSameLetters1(){
        let codewordSolver = CodewordSolver()
        codewordSolver.parse(query: "..11..")
        XCTAssert(codewordSolver.isMatch(word: "balled"))
        XCTAssertFalse(codewordSolver.isMatch(word: "balked"))
    }

    func testSameLetters2(){
        let codewordSolver = CodewordSolver()
        codewordSolver.parse(query: "112..12.")
        XCTAssert(codewordSolver.isMatch(word: "aardvark"))
        XCTAssertFalse(codewordSolver.isMatch(word: "aardverk"))
        XCTAssertFalse(codewordSolver.isMatch(word: "aardvask"))
        XCTAssertFalse(codewordSolver.isMatch(word: "wardvark"))
    }
    //Unknown letter is the same
    func testSameLetters3(){
        let codewordSolver = CodewordSolver()
        codewordSolver.parse(query: "112..12.")
        XCTAssertFalse(codewordSolver.isMatch(word: "aardaark"))
        XCTAssertFalse(codewordSolver.isMatch(word: "aardvara"))
        XCTAssertFalse(codewordSolver.isMatch(word: "wardrark"))
    }
    func testSameLetters4(){
        let codewordSolver = CodewordSolver()
        codewordSolver.parse(query: "12345671234567")
        XCTAssert(codewordSolver.isMatch(word: "abcdefgabcdefg"))
        XCTAssertFalse(codewordSolver.isMatch(word: "abcdefgabcdefk"))
    }
    
    func testUnknownLetters1(){
        let codewordSolver = CodewordSolver()
        codewordSolver.parse(query: ".l.ph...")
        XCTAssert(codewordSolver.isMatch(word: "eliphant"))
        XCTAssertFalse(codewordSolver.isMatch(word: "elephant"))
    }
}
