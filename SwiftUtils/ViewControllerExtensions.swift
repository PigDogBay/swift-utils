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
    public func mpdbShowAlert(title: String, msg : String)
    {
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        let controller = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(action)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    public func mpdbCheckIsFirstTime()->Bool
    {
        let key = "HasWelcomeShown"
        let defaults = NSUserDefaults.standardUserDefaults()
        let firstTimeSetting = defaults.objectForKey(key) as? Bool
        if firstTimeSetting == nil
        {
            defaults.setBool(true, forKey: key)
            defaults.synchronize()
            return true
        }
        return false
    }
}