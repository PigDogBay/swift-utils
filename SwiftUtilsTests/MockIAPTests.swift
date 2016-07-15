//
//  MockIAP.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 06/07/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import XCTest
import SwiftUtils

class MockIAPTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    //Expected usage
    func testAddObserver1() {
        let iapDelegate = MockIAPDelegate()
        let target = MockIAP()
        target.observable.addObserver("test", observer: iapDelegate)
        
        target.requestPurchase("")
        sleep(2)
        XCTAssert(iapDelegate.purchaseRequestCount==1)
        
        target.observable.removeObserver("test")
        
    }
    //Add observer twice
    func testAddObserver2() {
        let iapDelegate = MockIAPDelegate()
        let target = MockIAP()
        target.observable.addObserver("test", observer: iapDelegate)
        target.observable.addObserver("test", observer: iapDelegate)
        
        target.requestPurchase("")
        sleep(2)
        XCTAssert(iapDelegate.purchaseRequestCount==1)
        
        target.observable.removeObserver("test")
   
    }
    //Add observer twice
    func testRemoveObserver1() {
        let iapDelegate = MockIAPDelegate()
        let target = MockIAP()
        target.observable.addObserver("test", observer: iapDelegate)
        target.observable.removeObserver("test")
        target.requestPurchase("")
        XCTAssert(iapDelegate.purchaseRequestCount==0)
    }
    
    func testRequestProducts()
    {
        let PRODUCT_ID = "com.anagramsolver.pro"
        let PRODUCT = IAPProduct(id: PRODUCT_ID,price:"£1.99", title:"Go Pro", description:"No Ads, Bigger Dictionary")
        

        let iapDelegate = MockIAPDelegate()
        let target = MockIAP()
        target.serverProducts.append(PRODUCT)
        target.observable.addObserver("test", observer: iapDelegate)
        
        target.requestProducts()
        sleep(2)
        let product = target.getProduct(PRODUCT_ID)
        XCTAssert(!(product==nil))
        target.observable.removeObserver("test")
        
    }
    
    
    
    
    
    

}
