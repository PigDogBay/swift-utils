//
//  IAPObservable.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 06/07/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import Foundation

//
// Helper class to handle the IAPDelegate events
//
open class IAPObservable
{
    fileprivate var observersDictionary : [String : IAPDelegate] = [:]

    public init(){
    }
    open func addObserver(_ name: String, observer: IAPDelegate) {
        observersDictionary[name]=observer
    }
    open func removeObserver(_ name: String) {
        observersDictionary.removeValue(forKey: name)
    }
    open func onPurchaseRequestCompleted(_ productID : String)
    {
        for (_,observer) in observersDictionary
        {
            observer.purchaseRequest(productID)
        }
    }
    open func onRestorePurchaseCompleted(_ productID : String)
    {
        for (_,observer) in observersDictionary
        {
            observer.restoreRequest(productID)
        }
    }
    open func onProductsRequestCompleted()
    {
        for (_,observer) in observersDictionary
        {
            observer.productsRequest()
        }
    }
    open func onPurchaseRequestFailed(_ productID : String)
    {
        for (_,observer) in observersDictionary
        {
            observer.purchaseFailed(productID)
        }
    }
}
