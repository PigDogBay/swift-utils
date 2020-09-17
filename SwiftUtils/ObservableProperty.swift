//
//  ObservableProperty.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 21/09/2018.
//  Copyright © 2018 MPD Bailey Technology. All rights reserved.
//

import Foundation

public class ObservableProperty<T : Equatable> {
    public typealias Observer = (T) -> Void
    
    private var observers = [String : Observer]()
    
    //To synchronize functions, see
    //https://stackoverflow.com/questions/24045895/what-is-the-swift-equivalent-to-objective-cs-synchronized
    private var internalValue : T
    private let internalQueue : DispatchQueue = DispatchQueue(label: "lockingQueue")
    
    public var value : T {
        get {
            return internalQueue.sync{internalValue}
        }
        set (newValue){
            internalQueue.sync {
                if newValue != internalValue {
                    internalValue = newValue
                    for (_, ob) in observers {
                        ob(internalValue)
                    }
                }
            }
        }
    }
    public init (_ v : T){
        internalValue = v
    }
    
    //Need to use @escaping as the closure Observer will be called after this function returns
    public func addObserver(named : String, observer : @escaping Observer){
        internalQueue.sync{
            observers[named] =  observer
        }
    }
    public func removeObserver(named : String){
        internalQueue.sync {
            _ = observers.removeValue(forKey: named)
        }
    }
    public func removeAllObservers(){
        internalQueue.sync {
            observers.removeAll()
        }
    }
}
