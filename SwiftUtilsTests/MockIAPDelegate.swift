//
//  MockIAPDelegate.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 06/07/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import Foundation
import SwiftUtils

class MockIAPDelegate: IAPDelegate {

    var restoreRequestCount = 0;
    var productsRequestCount = 0;
    var purchaseRequestCount = 0;
    var purchaseFailedCount = 0;
    
    //MARK:- IAPDelegate
    func restoreRequest(productID : String) {
        restoreRequestCount += 1
    }
    func productsRequest() {
        productsRequestCount += 1
        
    }
    func purchaseRequest(productID : String) {
        purchaseRequestCount += 1
    }
    func purchaseFailed(productID : String) {
        purchaseFailedCount += 1
        
    }

    
    
}
