//
//  IAPData.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 06/07/2016.
//  Copyright © 2016 MPD Bailey Technology. All rights reserved.
//

import Foundation

public struct IAPProduct
{
    public let id : String
    public let price : String
    public let title : String
    public let description : String
    
    public init(id : String, price : String, title : String, description : String){
        self.id = id
        self.description = description
        self.price = price
        self.title = title
    }
}