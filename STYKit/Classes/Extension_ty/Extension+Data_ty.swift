//
//  Extension+Data.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Foundation

public extension Data {
    var sizeKB_ty: CGFloat {
        get {
            return CGFloat(self.count) / 1024.0
        }
    }
    
    var sizeMB_ty: CGFloat {
        get {
            return CGFloat(self.sizeKB_ty) / 1024.0
        }
    }
}
