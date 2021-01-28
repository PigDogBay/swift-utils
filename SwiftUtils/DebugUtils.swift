//
//  DebugUtils.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 10/07/2020.
//  Copyright © 2020 MPD Bailey Technology. All rights reserved.
//

import Foundation

public func mpdbCurrentQueueName() -> String? {
    let name = __dispatch_queue_get_label(nil)
    return String(cString: name, encoding: .utf8)
}

public func mpdbLogCurrentQueueName() {
    print("(MPDB SwiftUtils) Current Queue: \(mpdbCurrentQueueName() ?? "nil")")
}

public struct Timing {
    private let start = CFAbsoluteTimeGetCurrent()
    public init(){}
    
    public var elapsedSeconds : Double {
        return CFAbsoluteTimeGetCurrent() - start
    }
    
    public func log() {
        print("Time taken: \(elapsedSeconds)s")
    }
}
