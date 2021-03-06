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
    public func mpdbShowErrorAlert(_ title: String, msg : String)
    {
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        let controller = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    public func mpdbShowAlert(_ title: String, msg : String)
    {
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        let controller = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    public func mpdbCheckIsFirstTime()->Bool
    {
        let key = "HasWelcomeShown"
        let defaults = UserDefaults.standard
        let firstTimeSetting = defaults.object(forKey: key) as? Bool
        if firstTimeSetting == nil
        {
            defaults.set(true, forKey: key)
            return true
        }
        return false
    }
}

extension UIColor {
    public func mpdbPrintRGB(){
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        print("Color R:\(red) G:\(green) B:\(blue) A:\(alpha)")
    }
}
