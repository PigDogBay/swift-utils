//
//  RandomQueryTests.swift
//  SwiftUtilsTests
//
//  Created by Mark Bailey on 14/08/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Foundation
import XCTest
import SwiftUtils

class RandomQueryTests: XCTestCase {

    func testAnagram1(){
        let randomQuery = RandomQuery()
        let actual = randomQuery.anagram(numberOfVowels: 3, numberOfConsonants: 6)
        print(actual)
        XCTAssertEqual(actual.length, 9)
    }
}
