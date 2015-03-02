//
//  WordSearchTests.swift
//  Anagram Solver
//
//  Created by Mark Bailey on 10/02/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit
import XCTest
import SwiftUtils

class WordSearchTests: XCTestCase {

    var target : WordSearch!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let wordlist = WordList()
        target = WordSearch(wordList: wordlist)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPreProcessQuery1() {
        let actual = target.preProcessQuery("m.g.c")
        XCTAssertEqual(actual,"m.g.c")
    }
    func testPreProcessQuery2() {
        let actual = target.preProcessQuery("m4k2")
        XCTAssertEqual(actual,"m....k..")
    }
    func testPreProcessQuery3() {
        let actual = target.preProcessQuery("M.G.C")
        XCTAssertEqual(actual,"m.g.c")
    }
    func testPreProcessQuery4() {
        let actual = target.preProcessQuery("the quick brown fox jumped over the lazy dog")
        XCTAssertEqual(actual,"the quick brown fox jumped ove")
    }
    func testPreProcessQuery5() {
        let actual = target.preProcessQuery("m?g?c")
        XCTAssertEqual(actual,"m.g.c")
    }
    func testGetQueryType()
    {
        XCTAssertEqual(SearchType.Crossword, target.getQueryType("m.g.c"))
        XCTAssertEqual(SearchType.WildcardAndCrossword, target.getQueryType("m.g@"))
        XCTAssertEqual(SearchType.Wildcard, target.getQueryType("mag@"))
        XCTAssertEqual(SearchType.Anagram, target.getQueryType("magic"))
        XCTAssertEqual(SearchType.Supergram, target.getQueryType("magic++"))
        XCTAssertEqual(SearchType.SupergramWild, target.getQueryType("magic*"))
        XCTAssertEqual(SearchType.TwoWordAnagram, target.getQueryType("monkey magic"))
    }
    
    func testPostProcessQuery1()
    {
        XCTAssertEqual("m.g.c", target.postProcessQuery("m.g.c", type: SearchType.Crossword))
        XCTAssertEqual("m.g@", target.postProcessQuery("m.g@", type: SearchType.WildcardAndCrossword))
        XCTAssertEqual("@mag@", target.postProcessQuery("@mag@", type: SearchType.Wildcard))
        XCTAssertEqual("magic", target.postProcessQuery("magic", type: SearchType.Anagram))
        XCTAssertEqual("magic++", target.postProcessQuery("magic++", type: SearchType.Supergram))
        XCTAssertEqual("magic*", target.postProcessQuery("magic*", type: SearchType.SupergramWild))
        XCTAssertEqual("monkey magic", target.postProcessQuery("monkey magic", type: SearchType.TwoWordAnagram))
    }
    func testPostProcessQuery2()
    {
        XCTAssertEqual("m.g.c", target.postProcessQuery("m*.g@.ß€?c", type: SearchType.Crossword))
        XCTAssertEqual("m.g@", target.postProcessQuery("m.!!g@*", type: SearchType.WildcardAndCrossword))
        XCTAssertEqual("@mag@", target.postProcessQuery("@maAB?G%^&*..g@", type: SearchType.Wildcard))
        XCTAssertEqual("magic", target.postProcessQuery("mag!@£?$#¢∞ic", type: SearchType.Anagram))
        XCTAssertEqual("magic++", target.postProcessQuery("ma..*?#FFgic++", type: SearchType.Supergram))
        XCTAssertEqual("magic*", target.postProcessQuery("magi£#.?.c*++", type: SearchType.SupergramWild))
        XCTAssertEqual("monkey magic", target.postProcessQuery("mo?nkƒ®†∆ø^∆~åßHGY.#*ßey magic", type: SearchType.TwoWordAnagram))
    }
    func testPostProcessQuery3()
    {
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.Crossword))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.WildcardAndCrossword))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.Wildcard))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.Anagram))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.Supergram))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.SupergramWild))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.TwoWordAnagram))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
