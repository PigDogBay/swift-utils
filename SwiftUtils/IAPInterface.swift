//
//  IAPInterface.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 06/07/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import Foundation

public protocol IAPInterface
{
    var observable : IAPObservable {get}
    func canMakePayments() -> Bool
    func requestProducts()
    func requestPurchase(_ productID : String)
    func restorePurchases()
    
    func getProduct(_ productID : String) -> IAPProduct?
}
