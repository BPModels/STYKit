//
//  Extension+DispatchQueue_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import Foundation
import UIKit

public extension DispatchQueue {
    
    private static var _onceTracker_ty = [String]()

    class func once_ty(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker_ty.contains(token) {
            return
        }
        
        _onceTracker_ty.append(token)
        block()
    }
}
