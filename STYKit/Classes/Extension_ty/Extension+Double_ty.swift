//
//  Extension+Double.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Foundation

public extension Double {

    /// 获取小时、分钟和秒钟的字符串
    func hourMinuteSecondStr_ty(space_ty mark_ty: String = ":") -> String {
        let h_ty = self.hour_ty()
        let m_ty = self.minute_ty() % 60
        let s_ty = self.second_ty() % 60
        return String(format: "%02d%@%02d%@%02d", h_ty, mark_ty, m_ty, mark_ty, s_ty)
    }

    /// 获取分钟和秒钟的字符串
    func minuteSecondStr_ty(space_ty mark_ty: String = ":") -> String {
        let m_ty = self.minute_ty()
        let s_ty = self.second_ty() % 60
        return String(format: "%02d%@%02d", m_ty, mark_ty, s_ty)
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
    func byteFormat_ty(includesUnit_ty: Bool = true) -> String {
        guard self > 0 else {
            return includesUnit_ty ? "0K" : "0"
        }
        let units_ty = ["B", "K", "M", "G", "T", "P", "E", "Z", "Y"]
        let unit_ty = 1024.00

        let exp_ty: Int = Int(log(self) / log(unit_ty))
        var pre_ty: Double = 0
        if self > 1024 {
            pre_ty = self / pow(unit_ty, Double(exp_ty))
        } else {
            pre_ty = self / unit_ty
        }
        return String.init(format: "%.2f%@", pre_ty, units_ty[exp_ty])
    }
}
