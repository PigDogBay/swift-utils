//
//  WordMatchesTests.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 10/01/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import XCTest
import SwiftUtils

class WordFormatterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBlankFormatter1(){
        let target = BlankFormatter("magka++", color: UIColor.red)
        XCTAssertEqual(target.format("magic"),"magic (ka)")
    }
    func testBlankFormatter2(){
        let target = BlankFormatter("aage++", color: UIColor.red)
        let attrStr = target.formatAttributed("babbage")
        let attributes1 = attrStr.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual(attributes1.count, 1)
        XCTAssertEqual(attributes1.first?.key, NSAttributedStringKey.foregroundColor)
        XCTAssertEqual(attributes1.first?.value as! UIColor, UIColor.red)
        let attributes2 = attrStr.attributes(at: 1, effectiveRange: nil)
        XCTAssertEqual(attributes2.count, 0)
        let attributes3 = attrStr.attributes(at: 2, effectiveRange: nil)
        XCTAssertEqual(attributes3.count, 1)
        let attributes4 = attrStr.attributes(at: 3, effectiveRange: nil)
        XCTAssertEqual(attributes4.count, 1)
    }
    func testBlankFormatter3(){
        let target = BlankFormatter("magka++", color: UIColor.red)
        XCTAssertEqual(target.formatAttributed("magic").string,"magic (ka)")
    }
    func testBlankFormatter4(){
        let target = BlankFormatter("llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch++", color: UIColor.red)
        let attrStr = target.formatAttributed("llanzfairpwllgwyngyllgogerychwyrndrobwllllantyxsiliogogogoch")
        XCTAssertEqual(attrStr.string,
                       "llanzfairpwllgwyngyllgogerychwyrndrobwllllantyxsiliogogogoch")
        let attributes1 = attrStr.attributes(at: 4, effectiveRange: nil)
        XCTAssertEqual(attributes1.count, 1)
        let attributes2 = attrStr.attributes(at: 10, effectiveRange: nil)
        XCTAssertEqual(attributes2.count, 0)
        let attributes3 = attrStr.attributes(at: 46, effectiveRange: nil)
        XCTAssertEqual(attributes3.count, 1)
    }
    func testSupergramFormatter1(){
        let target = SupergramFormatter("holly*", color: UIColor.blue)
        let attrStr = target.formatAttributed("owlishly")
        XCTAssertEqual(attrStr.string, "owlishly")
        let attributes1 = attrStr.attributes(at: 1, effectiveRange: nil)
        //w
        XCTAssertEqual(attributes1.count, 1)
        XCTAssertEqual(attributes1.first?.key, NSAttributedStringKey.foregroundColor)
        XCTAssertEqual(attributes1.first?.value as! UIColor, UIColor.blue)
        //l
        let attributes2 = attrStr.attributes(at: 2, effectiveRange: nil)
        XCTAssertEqual(attributes2.count, 0)
        //s
        let attributes3 = attrStr.attributes(at: 4, effectiveRange: nil)
        XCTAssertEqual(attributes3.count, 1)
    }
    func testSupergramFormatter2(){
        let target = SupergramFormatter("ylloh", color: UIColor.blue)
        let attrStr = target.formatAttributed("holly")
        XCTAssertEqual(attrStr.string, "holly")
        let attributes1 = attrStr.attributes(at: 0, effectiveRange: nil)
        XCTAssertEqual(attributes1.count, 0)
    }
    
    func testSubAnagramFormatting1() {
        let target = SubAnagramFormatter("magicka")
        XCTAssertEqual(target.format("magic"),"magic (ka)")
    }
    
    func testSubAnagramFormatting2() {
        let target = SubAnagramFormatter("ylloh")
        XCTAssertEqual(target.format("holly"),"holly")
    }
    
    func testSubAnagramFormatting3() {
        let target = SubAnagramFormatter("magicka")
        XCTAssertEqual(target.format("i"),"i (magcka)")
    }

    func testSubAnagramFormatting4() {
        let target = SubAnagramFormatter("llanfairpwllgwyngyllgogeryqjxzchwyrndrobwllllantysiliogogogoch")
        XCTAssertEqual(target.format(
            "llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch"),
            "llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch (qjxz)")
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
