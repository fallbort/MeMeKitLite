//
//  Calendar+Extensions.swift
//  MeMeKit
//
//  Created by xfb on 2023/8/13.
//

import Foundation

extension NSObject {
    //2012-03,一月有多少天
    @objc public static func getDaysByMonthString(month:String,dateFormat:String) -> NSInteger {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        if let date = formatter.date(from: month) {
            let calendar = Calendar(identifier: .gregorian)
            if let range = calendar.range(of: .day, in: .month, for: date) {
                return range.count
            }
        }
        
        return 0
    }
    
    //yyyy-MM-dd，一月的第一天是星际几,周日是1
    @objc public static func getWeakDayByDayString(day:String,dateFormat:String) -> NSInteger {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        if let date = formatter.date(from: day) {
            let calendar = Calendar(identifier: .gregorian)
            let weekday = calendar.component(.weekday, from: date)
            return weekday
        }
        
        return 0
    }
}

extension NSObject {
    
    @objc public static func addingRmoving(date:Date, months: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.month = months
        
        return calendar.date(byAdding: components, to: date)
    }
    
    @objc public static func getWeekBegin() -> Date {
        let oneWeek:Int = 24*3600*7
        let curTime:Int = (Int)(Date().timeIntervalSince1970)
        let count = curTime / oneWeek
        let beginTime = (TimeInterval)(oneWeek * count - 8 * 3600) - 3 * 24 * 3600
        return Date(timeIntervalSince1970: beginTime)
    }
}

extension Calendar {
    public static func getDaysByMonthString(month:String,dateFormat:String) -> NSInteger {
        return NSObject.getDaysByMonthString(month: month, dateFormat: dateFormat)
    }
    
    public static func getWeakDayByDayString(day:String,dateFormat:String) -> NSInteger {
        return NSObject.getWeakDayByDayString(day: day, dateFormat: dateFormat)
    }
    
    public static func addingRmoving(date:Date, months: Int) -> Date? {
        return NSObject.addingRmoving(date: date, months: months)
    }
}


