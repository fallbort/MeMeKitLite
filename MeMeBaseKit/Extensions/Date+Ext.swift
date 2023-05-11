//
//  Date+Ext.swift
//  MeMe
//
//  Created by LuanMa on 2016/10/25.
//  Copyright © 2016年 sip. All rights reserved.
//

import Foundation

extension Date {
	public func string(withFormat format: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: self)
	}
    
    public func formattedDateWithMultiLang(showTime: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.defaultDate = self
        formatter.dateStyle = .medium
        formatter.timeStyle = showTime ? .short : .none
        return formatter.string(from: self)
    }
    
    public func getTomorrowDay() -> Date? {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year,.month, .day], from: self)
        if let day = dateComponents.day{
            dateComponents.day = day + 1
            return calendar.date(from: dateComponents)
        }
        return nil
    }
    
    public func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
    
    public func getWeekDayName() -> String? {
        let weekday = Calendar.current.component(Calendar.Component.weekday, from: self)
        let index = (weekday - 1)
        let formmater = DateFormatter()
        let key = NELocalize.currentSettingLanguage()
        formmater.locale = NSLocale(localeIdentifier: key) as? Locale
        if let resultString = formmater.shortWeekdaySymbols?[index] {
            return resultString
        }
        
        return nil
    }
}
