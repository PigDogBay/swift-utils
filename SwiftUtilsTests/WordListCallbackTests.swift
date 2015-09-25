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
    func update(result: String) {
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
    
}
