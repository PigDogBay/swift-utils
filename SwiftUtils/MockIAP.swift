//
//  MockIAP.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 06/07/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import Foundation

public class MockIAP : IAPInterface
{
    public var observable: IAPObservable
    public var serverProducts : [IAPProduct] = []
    public var retrievedProducts : [IAPProduct] = []
    public var canMakePaymentsFlag = true
    public var failPurchaseFlag = false
    public var delay : Int64 = 1
    
    public init(){
        observable = IAPObservable()
    }
    public func canMakePayments() -> Bool {
        return canMakePaymentsFlag
    }
    public func requestPurchase(productID: String) {
        let time = dispatch_time(DISPATCH_TIME_NOW,delay * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            if self.failPurchaseFlag
            {
                self.observable.onPurchaseRequestFailed(productID)
            }
            else
            {
                self.observable.onPurchaseRequestCompleted(productID)
            }
        }
    }
    public func restorePurchases() {
        let time = dispatch_time(DISPATCH_TIME_NOW,delay * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            for p in self.serverProducts
            {
                self.observable.onRestorePurchaseCompleted(p.id)
            }
        }
        
    }
    public func requestProducts() {
        print("request Products")
        let time = dispatch_time(DISPATCH_TIME_NOW,delay * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            print("request Products - Dispatched")
            self.retrievedProducts = self.serverProducts
            self.observable.onProductsRequestCompleted()
        }
    }
    public func getProduct(productID : String) -> IAPProduct?
    {
        for p in retrievedProducts
        {
            if p.id == productID {
                return p
            }
        }
        return nil
    }

    
    
}
