//
//  MockIAP.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 06/07/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import Foundation

open class MockIAP : IAPInterface
{
    open var observable: IAPObservable
    open var serverProducts : [IAPProduct] = []
    open var retrievedProducts : [IAPProduct] = []
    open var canMakePaymentsFlag = true
    open var failPurchaseFlag = false
    open var delay : Int64 = 1
    
    public init(){
        observable = IAPObservable()
    }
    open func canMakePayments() -> Bool {
        return canMakePaymentsFlag
    }
    open func requestPurchase(_ productID: String) {
        let time = DispatchTime.now() + Double(delay * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).asyncAfter(deadline: time)
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
    open func restorePurchases() {
        let time = DispatchTime.now() + Double(delay * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).asyncAfter(deadline: time)
        {
            for p in self.serverProducts
            {
                self.observable.onRestorePurchaseCompleted(p.id)
            }
        }
        
    }
    open func requestProducts() {
        print("request Products")
        let time = DispatchTime.now() + Double(delay * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).asyncAfter(deadline: time)
        {
            print("request Products - Dispatched")
            self.retrievedProducts = self.serverProducts
            self.observable.onProductsRequestCompleted()
        }
    }
    open func getProduct(_ productID : String) -> IAPProduct?
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
