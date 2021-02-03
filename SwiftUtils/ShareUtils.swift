//
//  ShareUtils.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 28/07/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Foundation

/*
 Based on
 https://stackoverflow.com/questions/56784722/swiftui-send-email
 Add this to info.plist
 <key>LSApplicationQueriesSchemes</key>
 <array>
     <string>googlegmail</string>
     <string>ms-outlook</string>
     <string>readdle-spark</string>
     <string>ymail</string>
 </array>
 
 Note only tested with gmail, yahoo and default apps
 Spark/Outlook not tested
 
 */
public func mpdbCreateEmailUrl(to: String, subject: String, body: String) -> URL? {
    let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

    let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
    let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
    let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")

    if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
        return gmailUrl
    } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
        return outlookUrl
    } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
        return yahooMail
    } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
        return sparkUrl
    } else if let defaultUrl = defaultUrl, UIApplication.shared.canOpenURL(defaultUrl){
        return defaultUrl
    }
    return nil
}

public func mpdbShowSettings(){
    let application = UIApplication.shared
    let url = URL(string: UIApplication.openSettingsURLString)! as URL
    if application.canOpenURL(url){
        application.open(url,options: [:],completionHandler: nil)
    }
}
