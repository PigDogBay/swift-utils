//
//  ViewControllerExtensions.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 04/03/2015.
//  Copyright (c) 2015 MPD Bailey Technology. All rights reserved.
//

import UIKit

extension UIViewController
{
    public func mpdbShowErrorAlert(title: String, msg : String)
    {
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        let controller = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(action)
        self.presentViewController(controller, animated: true, completion: nil)
    }
}