//
//  TYHomeModel.swift
//  STYKit_Example
//
//  Created by apple on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

import ObjectMapper

struct TYHomeModel: Mappable {
    
    var rongCloudAppKey: String?
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        rongCloudAppKey <- map["rongCloudAppKey"]
    }
}
