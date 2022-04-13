//
//  Extension+Double.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Foundation

public extension Double {

    /// 获取小时、分钟和秒钟的字符串
    func hourMinuteSecondStr_ty(space mark: String = ":") -> String {
        let h = self.hour_ty()
        let m = self.minute_ty() % 60
        let s = self.second_ty() % 60
        return String(format: "%02d%@%02d%@%02d", h, mark, m, mark, s)
    }

    /// 获取分钟和秒钟的字符串
    func minuteSecondStr_ty(space mark: String = ":") -> String {
        let m = self.minute_ty()
        let s = self.second_ty() % 60
        return String(format: "%02d%@%02d", m, mark, s)
    }
    
    /// 转换成秒
    func second_ty() -> Int {
        /// 四舍五入
        return Int(self.rounded())
    }

    /// 转换成分钟
    func minute_ty() -> Int {
        return second_ty() / 60
    }

    /// 转换成小时
    func hour_ty() -> Int {
        return minute_ty() / 60
    }
    
    /// 转换格式
    func toDate_ty() -> Date {
        return Date(timeIntervalSince1970: self)
    }
    
    /// 字节转换
    /// - Parameter includesUnit: 是否包含单位
    /// - Returns: 格式化字符串
    func byteFormat_ty(includesUnit:Bool = true) -> String {
        guard self > 0 else {
            return includesUnit ? "0K" : "0"
        }
        let units = ["B", "K", "M", "G", "T", "P", "E", "Z", "Y"]
        let unit = 1024.00

        let exp:Int = Int(log(self) / log(unit))
        var pre:Double = 0
        if self > 1024 {
            pre = self / pow(unit, Double(exp))
        } else {
            pre = self / unit
        }
        return String.init(format: "%.2f%@", pre, units[exp])
    }
}
