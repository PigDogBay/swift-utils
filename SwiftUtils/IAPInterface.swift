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
    func requestPurchase(productID : String)
    func restorePurchase(productID : String)
    
    func getProduct(productID : String) -> IAPProduct?
}
