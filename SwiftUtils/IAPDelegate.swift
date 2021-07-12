//
//  IAPDelegate.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 06/07/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import Foundation

public protocol IAPDelegate : AnyObject
{
    func productsRequest()
    func purchaseRequest(_ productID : String)
    func restoreRequest(_ productID : String)
    func purchaseFailed(_ productID : String)

}
