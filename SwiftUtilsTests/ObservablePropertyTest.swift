//
//  ObservablePropertyTest.swift
//  SwiftUtilsTests
//
//  Created by Mark Bailey on 21/09/2018.
//  Copyright © 2018 MPD Bailey Technology. All rights reserved.
//

import XCTest
import SwiftUtils

class ObservablePropertyTest: XCTestCase {
    enum Fruit {
        case apple, pear, banana, orange, blueberry
    }
    var intNewValue : Int?
    var fruitNewValue : Fruit?
    var callbackCount = 0
    
    private func intChanged(newValue : Int){
        intNewValue = newValue
    }
    private func fruitChanged(newValue : Fruit){
        fruitNewValue = newValue
        callbackCount = callbackCount + 1
    }
    override func setUp() {
        super.setUp()
        callbackCount = 0
    }
    
    
    func test_int_types() {
        let target = ObservableProperty<Int>(42)
        target.addObserver(named: "int", observer: intChanged)
        target.value = 6
        target.removeObserver(named: "int")
        XCTAssertEqual(6, intNewValue)
    }
    
    func test_enum_types(){
        let target = ObservableProperty<Fruit>(.apple)
        target.addObserver(named: "fruit", observer: fruitChanged)
        target.value = .blueberry
        target.removeObserver(named: "fruit")
        XCTAssertEqual(.blueberry, fruitNewValue)
    }
    func test_only_callback_on_change(){
        let target = ObservableProperty<Fruit>(.apple)
        target.addObserver(named: "fruit", observer: fruitChanged)
        target.value = .blueberry
        XCTAssertEqual(1, callbackCount)
        target.value = .blueberry
        XCTAssertEqual(1, callbackCount)
        target.removeObserver(named: "fruit")
    }
    
}
