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

    class func once_ty(token_ty: String, block_ty:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker_ty.contains(token_ty) {
            return
        }
        
        _onceTracker_ty.append(token_ty)
        block_ty()
    }
}
