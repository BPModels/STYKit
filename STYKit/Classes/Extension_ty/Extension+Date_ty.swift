//
//  Extension+Date_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/19.
//

import Foundation

let componentFlags_ty = Set<Calendar.Component>([.day, .month, .year, .hour,.minute,.second,.weekday,.weekdayOrdinal])

public enum TYDateFormatType_ty: String {
    case hm_ty               = "HH:mm"
    case ymdDot_ty           = "yyyy.MM.dd"
    case ymdhmDot_ty         = "yyyy.MM.dd HH:mm"
    case md_ty               = "MM月dd日"
    case ymd_ty              = "yyyy年MM月dd日"
    case ymdhm_ty            = "yyyy年MM月dd日 HH:mm"
    case ymdhms_ty           = "yyyy年MM月dd日 HH:mm:ss"
    case ymdMiddleLine_ty    = "yyyy-MM-dd"
    case ymdhmsMiddleLine_ty = "yyyy-MM-dd HH:mm:ss"
    case ymdhmSlash_ty       = "yyyy/MM/dd HH:mm"
}

public extension Date {

    /// 转换本地时间
    /// - Returns: 转换后的东八区时间
    func local_ty() -> Date {
        guard let zone_ty = TimeZone(identifier: "Asia/Shanghai") else {
            return self
        }
        let interval_ty = zone_ty.secondsFromGMT(for: self)
        return self.addingTimeInterval(Double(interval_ty))
    }
    
    /// 当前系统时间是否是24小时制
    static var checkDateSetting24Hours_ty: Bool {
        var is24Hours_ty: Bool   = true
        let dateStr_ty: String   = Date().description(with: Locale.current)
        let sysbols_ty: [String] = [Calendar.current.amSymbol, Calendar.current.pmSymbol]
        for symbol_ty in sysbols_ty where dateStr_ty.range(of: symbol_ty) != nil {
            is24Hours_ty = false
            break
        }
        return is24Hours_ty
    }

    /// 获取当前时间 (格林威治标准时间)
    static func getCurrentDate_ty() -> Date {
        let date_ty     = Date()
        let interval_ty = NSTimeZone.system.secondsFromGMT(for: date_ty)
        return date_ty.addingTimeInterval(TimeInterval(interval_ty))
    }

    /// 系统日历(中国制)
    var calendar_ty: Calendar {
        get{
            var calendar_ty = Calendar(identifier: .gregorian)
            calendar_ty.locale   = Locale(identifier: "zh_CN")
            calendar_ty.timeZone = TimeZone(identifier: "UTC")!
            return calendar_ty
        }
    }

    /// 系统当前年(中国制)
    var year_ty: Int {
        get{
            let components_ty = calendar_ty.dateComponents(componentFlags_ty, from: self)
            return components_ty.year!
        }
    }

    /// 系统当前月(中国制)
    var month_ty: Int {
        get{
            let components_ty = calendar_ty.dateComponents(componentFlags_ty, from: self)
            return components_ty.month!
        }
    }

    /// 系统当前天(中国制)
    var day_ty: Int {
        get{
            let components_ty = calendar_ty.dateComponents(componentFlags_ty, from: self)
            return components_ty.day!
        }
    }

    /// 系统当前小时(中国制)
    var hour_ty: Int {
        get{
            let components_ty = calendar_ty.dateComponents(componentFlags_ty, from: self)
            return components_ty.hour!
        }
    }

    /// 系统当前分钟(中国制)
    var minute_ty: Int {
        get{
            let components_ty = calendar_ty.dateComponents(componentFlags_ty, from: self)
            return components_ty.minute!
        }
    }

    /// 系统当前秒(中国制)
    var second_ty: Int {
        get{
            let components_ty = calendar_ty.dateComponents(componentFlags_ty, from: self)
            return components_ty.second!
        }
    }

    /// *年*月*日
    var dateYMDString_ty: String {
        let formatter_ty = DateFormatter()
        formatter_ty.dateFormat = TYDateFormatType_ty.ymd_ty.rawValue
        return formatter_ty.string(from: self)
    }
    
    /// 返回当前系统日期字符串,格式:年-月-日 时:分:秒
    var dateString_ty: String {
        let formatter_ty = DateFormatter()
        formatter_ty.dateFormat = TYDateFormatType_ty.ymdhms_ty.rawValue
        return formatter_ty.string(from: self)
    }
    
    /// 根据类型，返回对应的字符串
    func dateFormatStr_ty(type_ty: TYDateFormatType_ty) -> String {
        let formatter_ty = DateFormatter()
        formatter_ty.dateFormat = type_ty.rawValue
        return formatter_ty.string(from: self)
    }

    /// 字符串转成制定格式的日期(中国制)
    func date_ty(datestr_ty: String, format_ty: String) -> Date? {
        let fmt_ty = DateFormatter()
        fmt_ty.locale     = Locale(identifier: "zh_CN")
        fmt_ty.timeZone   = TimeZone(identifier: "UTC")
        fmt_ty.dateFormat = format_ty
        let date_ty = fmt_ty.date(from: datestr_ty)
        return date_ty
    }
    
    /// 计算两个日期之间的天数
    func dateInterval_ty(endDate_ty: Date?) -> Int {
        guard let end_ty = endDate_ty else {
            return 0
        }
        let components_ty = Calendar.current.dateComponents([.day], from: end_ty, to: self)
        return components_ty.day ?? 0
    }

    /// 根据指定格式,返回系统时间(中国制)
    /// e.g. "YYYY-MM-dd HH:mm:ss" 年-月-日 时:分:秒
    func dateWithFormatter_ty(formatter_ty: String) -> Date? {
        let fmt_ty = DateFormatter()
        fmt_ty.locale     = Locale(identifier: "zh_CN")
        fmt_ty.timeZone   = TimeZone(identifier: "UTC") //TimeZone(secondsFromGMT: +28800)!
        fmt_ty.dateFormat = formatter_ty
        let selfStr_ty    = fmt_ty.string(from: self)
        return fmt_ty.date(from: selfStr_ty)
    }

    /// 根据间隔时间,获得与当前系统时间间隔的时间值.
    /// 返回类型如下:
    ///
    ///     [calendar: gregorian (current) year: 0 month: 0 day: 0 hour: -1 minute: 0 second: 0 weekday: 0 isLeapMonth: false]
    ///
    /// - parameter second: 与当前系统时间间隔的秒数,如果是负数,则返回也是相应的负数时间
    func dateComponentFrom_ty(second_ty: Double) -> DateComponents {
        let interval_ty = TimeInterval(second_ty)
        let date2_ty    = Date(timeInterval: interval_ty, since: self)
        let c_ty        = NSCalendar.current
        
        var components_ty = c_ty.dateComponents([.year,.month,.day,.hour,.minute,.second,.weekday], from: self, to: date2_ty)
        components_ty.calendar = c_ty
        return components_ty
    }
    

    /// 用于IM的时间戳展示
    func timeStr_ty() -> String {
        let calendar_ty = Calendar.current
        let now_ty = self
//        let components = calendar.dateComponents([.year, .month, .weekOfMonth, .day, .hour, .minute, .second], from: self, to: Date())
        
        if calendar_ty.isDateInToday(self) {
            // 今天
//            if let minute = components.minute, minute >= 1 {
                let formatter_ty = DateFormatter()
                formatter_ty.dateFormat = "HH:mm"
                return formatter_ty.string(from: now_ty)
//            } else {
//                return "刚刚"
//            }
//        } else if calendar.isDateInYesterday(self) {
//            // 昨天
//            let formatter = DateFormatter()
//            formatter.dateFormat = "HH:mm"
//            return "昨天 " + formatter.string(from: now)
        } else if self.year_ty == Date().year_ty {
            // 本年
            let formatter_ty = DateFormatter()
            formatter_ty.dateFormat = "MM-dd HH:mm"
            return formatter_ty.string(from: now_ty)
        } else {
            // 往年
            let formatter_ty = DateFormatter()
            formatter_ty.dateFormat = "YYYY-MM-dd HH:mm"
            return formatter_ty.string(from: now_ty)
        }
    }
    
    /// 用于公告一类的时间展示
    func cardTimeStr_ty() -> String {
        let calendar_ty = Calendar.current
        let now_ty = self
        if calendar_ty.isDateInToday(self) {
            // 今天
            let formatter_ty = DateFormatter()
            formatter_ty.dateFormat = "HH:mm"
            return formatter_ty.string(from: now_ty)
        } else if self.year_ty == Date().year_ty {
            // 本年
            let formatter_ty = DateFormatter()
            formatter_ty.dateFormat = "MM-dd"
            return formatter_ty.string(from: now_ty)
        } else {
            // 往年
            let formatter_ty = DateFormatter()
            formatter_ty.dateFormat = "YYYY-MM-dd"
            return formatter_ty.string(from: now_ty)
        }
    }
    
    /// 获得day天后的日期
    func offsetDate_ty(offset_ty day_ty: Int) -> Date? {
        let gregorian_ty        = Calendar(identifier: .gregorian)
        var offsetComponents_ty = DateComponents()
        offsetComponents_ty.day = day_ty
        let offsetDate_ty       = gregorian_ty.date(byAdding: offsetComponents_ty, to: self, wrappingComponents: false)
        return offsetDate_ty
    }
}

extension Date {

    /// 根据时间获取年龄
    func age_ty() -> Int {
        let components_ty: Set<Calendar.Component> = Set(arrayLiteral: .year, .month, .day)

        // 出生日期转换 年月日
        let componentsUser_ty = Calendar.current.dateComponents(components_ty, from: self)
        let brithDateYear_ty  = componentsUser_ty.year  ?? 0
        let brithDateDay_ty   = componentsUser_ty.day   ?? 0
        let brithDateMonth_ty = componentsUser_ty.month ?? 0

        // 获取系统当前 年月日
        let componentsSystem_ty = Calendar.current.dateComponents(components_ty, from: Date())
        let currentDateYear_ty  = componentsSystem_ty.year  ?? 0
        let currentDateDay_ty   = componentsSystem_ty.day   ?? 0
        let currentDateMonth_ty = componentsSystem_ty.month ?? 0

        // 计算年龄
        var iAge_ty: Int = currentDateYear_ty - brithDateYear_ty - 1
        if ((currentDateMonth_ty > brithDateMonth_ty) || (currentDateMonth_ty == brithDateMonth_ty && currentDateDay_ty >= brithDateDay_ty)) {
            iAge_ty = iAge_ty + 1
        }

        return iAge_ty
    }
}
