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

    public func addObserver(name: String, observer: IAPDelegate) {
        observersDictionary[name]=observer
    }
    public func removeObserver(name: String) {
        observersDictionary.removeValueForKey(name)
    }
    func onPurchaseRequestCompleted(productID : String)
    {
        for (_,observer) in observersDictionary
        {
            observer.purchaseRequest(productID)
        }
    }
    func onRestorePurchaseCompleted(productID : String)
    {
        for (_,observer) in observersDictionary
        {
            observer.restoreRequest(productID)
        }
    }
    func onProductsRequestCompleted()
    {
        for (_,observer) in observersDictionary
        {
            observer.productsRequest()
        }
    }
    func onPurchaseRequestFailed(productID : String)
    {
        for (_,observer) in observersDictionary
        {
            observer.purchaseFailed(productID)
        }
    }
}