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
public class IAPObservable
{
    private var observersDictionary : [String : IAPDelegate] = [:]

    public init(){
    }
    public func addObserver(name: String, observer: IAPDelegate) {
        observersDictionary[name]=observer
    }
    public func removeObserver(name: String) {
        observersDictionary.removeValueForKey(name)
    }
    public func onPurchaseRequestCompleted(productID : String)
    {
        for (_,observer) in observersDictionary
        {
            observer.purchaseRequest(productID)
        }
    }
    public func onRestorePurchaseCompleted(productID : String)
    {
        for (_,observer) in observersDictionary
        {
            observer.restoreRequest(productID)
        }
    }
    public func onProductsRequestCompleted()
    {
        for (_,observer) in observersDictionary
        {
            observer.productsRequest()
        }
    }
    public func onPurchaseRequestFailed(productID : String)
    {
        for (_,observer) in observersDictionary
        {
            observer.purchaseFailed(productID)
        }
    }
}