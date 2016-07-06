//
//  IAPDelegate.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 06/07/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import Foundation

public protocol IAPDelegate : class
{
    func productsRequest()
    func purchaseRequest(productID : String)
    func restoreRequest(productID : String)
    func purchaseFailed(productID : String)

}