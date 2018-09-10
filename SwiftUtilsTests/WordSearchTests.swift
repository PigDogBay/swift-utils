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
    
    func testClean1()
    {
        var expected = ""
        var actual = target.clean(expected)
        XCTAssertEqual(actual, expected)

        expected = "1z9"
        actual = target.clean(expected)
        XCTAssertEqual(actual, expected)

        expected = "m.g.."
        actual = target.clean(expected)
        XCTAssertEqual(actual, expected)
        
        expected = "@ace"
        actual = target.clean(expected)
        XCTAssertEqual(actual, expected)
        
        expected = "manchester united"
        actual = target.clean(expected)
        XCTAssertEqual(actual, expected)
        
        expected = "abcdefghijklmnopqrstuvwxyz"
        actual = target.clean(expected)
        XCTAssertEqual(actual, expected)
    }
    func testClean2()
    {
        var actual = target.clean("       ")
        XCTAssertEqual(actual, "")

        actual = target.clean("       whitespace      ")
        XCTAssertEqual(actual, "whitespace")

        actual = target.clean("˚œ∑´®†¥åßΩ≈ç√∫~µ®øπ†¥˙©")
        XCTAssertEqual(actual, "")

        actual = target.clean("˚œ∑´®†¥åßΩok≈ç√∫~µ®øπ")
        XCTAssertEqual(actual, "ok")

        actual = target.clean("˚œ∑´®†¥å  o k  ßΩ≈ç√∫~µ®øπ")
        XCTAssertEqual(actual, "o k")
        
        actual = target.clean("AZ")
        XCTAssertEqual(actual, "az")

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
    func testPreProcessQuery7() {
        let actual = target.preProcessQuery(".a112332")
        XCTAssertEqual(actual,".a112332")
    }
    func testPreProcessQuery8() {
        let actual = target.preProcessQuery("?a112332")
        XCTAssertEqual(actual,".a112332")
    }
    func testPreProcessQuery9() {
        let actual = target.preProcessQuery("?a12332")
        XCTAssertEqual(actual,".a...........")
    }
    func testPreProcessQuery10() {
        target.findCodewords = false
        let actual = target.preProcessQuery(".a112332")
        XCTAssertEqual(actual,".a............")
    }

    func testGetQueryType1()
    {
        XCTAssertEqual(SearchType.crossword, target.getQueryType("m.g.c"))
        XCTAssertEqual(SearchType.wildcardAndCrossword, target.getQueryType("m.g@"))
        XCTAssertEqual(SearchType.wildcard, target.getQueryType("mag@"))
        XCTAssertEqual(SearchType.anagram, target.getQueryType("magic"))
        XCTAssertEqual(SearchType.blanks, target.getQueryType("magic++"))
        XCTAssertEqual(SearchType.supergram, target.getQueryType("magic*"))
        XCTAssertEqual(SearchType.twoWordAnagram, target.getQueryType("monkey magic"))
        XCTAssertEqual(SearchType.twoWordAnagram, target.getQueryType("funky is monkey"))
        XCTAssertEqual(SearchType.codeword, target.getQueryType(".a112332"))
        XCTAssertEqual(SearchType.codeword, target.getQueryType("1.a23321"))
        XCTAssertEqual(SearchType.crossword, target.getQueryType(".a12332"))
    }
    func testGetQueryType2()
    {
        target.findCodewords = false
        XCTAssertEqual(SearchType.crossword, target.getQueryType(".a112332"))
    }

    func testPostProcessQuery1()
    {
        XCTAssertEqual("m.g.c", target.postProcessQuery("m.g.c", type: SearchType.crossword))
        XCTAssertEqual("m.g@", target.postProcessQuery("m.g@", type: SearchType.wildcardAndCrossword))
        XCTAssertEqual("@mag@", target.postProcessQuery("@mag@", type: SearchType.wildcard))
        XCTAssertEqual("magic", target.postProcessQuery("magic", type: SearchType.anagram))
        XCTAssertEqual("magic++", target.postProcessQuery("magic++", type: SearchType.blanks))
        XCTAssertEqual("magic*", target.postProcessQuery("magic*", type: SearchType.supergram))
        XCTAssertEqual("monkey magic", target.postProcessQuery("monkey magic", type: SearchType.twoWordAnagram))
        XCTAssertEqual("funky is monkey", target.postProcessQuery("funky is monkey", type: SearchType.twoWordAnagram))
        XCTAssertEqual(".a112332", target.postProcessQuery(".a112332", type: SearchType.codeword))
    }
    func testPostProcessQuery2()
    {
        XCTAssertEqual("m.g.c", target.postProcessQuery("m*.g@.ß€?c", type: SearchType.crossword))
        XCTAssertEqual("m.g@", target.postProcessQuery("m.!!g@*", type: SearchType.wildcardAndCrossword))
        XCTAssertEqual("@mag@", target.postProcessQuery("@maAB?G%^&*..g@", type: SearchType.wildcard))
        XCTAssertEqual("magic", target.postProcessQuery("mag!@£?$#¢∞ic", type: SearchType.anagram))
        XCTAssertEqual("magic++", target.postProcessQuery("ma..*?#FFgic++", type: SearchType.blanks))
        XCTAssertEqual("magic*", target.postProcessQuery("magi£#.?.c*++", type: SearchType.supergram))
        XCTAssertEqual("monkey magic", target.postProcessQuery("mo?nkƒ®†∆ø^∆~åßHGY.#*ßey magic", type: SearchType.twoWordAnagram))
        XCTAssertEqual(".az112.332", target.postProcessQuery(".az#+@112.33#+@*2", type: SearchType.codeword))
        XCTAssertEqual(".a", target.postProcessQuery(".a112332", type: SearchType.crossword))
    }
    func testPostProcessQuery3()
    {
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.crossword))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.wildcardAndCrossword))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.wildcard))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.anagram))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.blanks))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.supergram))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.twoWordAnagram))
        XCTAssertEqual("", target.postProcessQuery("", type: SearchType.codeword))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
