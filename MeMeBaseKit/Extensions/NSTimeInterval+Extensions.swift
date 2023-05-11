//
//  TimeInterval+Extensions.swift
//  LiveCap
//
//  Created by Solomon English on 11/18/15.
//  Copyright © 2015 FunPlus. All rights reserved.
//

import Foundation

extension TimeInterval {
	public func millisecond() -> Int64 {
        return Int64(self * 1000)
    }
    public func toTimeStringWithFarmat(farmat: String = "yyyy.MM.dd HH:mm:ss") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.setLocalizedDateFormatFromTemplate(farmat)
        dateFormatter.dateFormat = farmat
        let str = dateFormatter.string(from: Date(timeIntervalSince1970: self))
        return str
        
    }
    public func isForeverBlocked()-> Bool {
        let endBlock = TimeInterval(180*24*60*60)
        if self > endBlock{
            return true
        }
        return false
    }
    public func toRemainingStringWithRemainingTime() -> String {
        
        let endBlock = TimeInterval(180*24*60*60)
        if self > endBlock{
            return ""
        }
        let str  = self.toRemainingString()
        
        let format = NELocalize.localizedString("forbid_unblock", comment: "")
        let msg = String(format: format, "\(str)")
        
        return msg
    }
    public func toRemainingStringWithNowTime(_ nowTime:TimeInterval) -> String {
        
        let toRemainingTime = TimeInterval(self - nowTime)
   
        let endBlock = TimeInterval(180*24*60*60)
        if toRemainingTime > endBlock{
            return ""
        }
        let str  = toRemainingTime.toRemainingString()
        
        let format = NELocalize.localizedString("%@后解禁。", comment: "")
        let msg = String(format: format, "\(str)")
        
        return msg
    }
    public func toRemainingString() -> String {
        let min = Int(ceil(self / 60))
        let hours = min / 60
        let days = hours / 24
        
        var shortString: String = ""
        if days > 0 {
            shortString = "\(days)" + NELocalize.localizedString("randomgift_lastprize_day", comment: "")
        }
        let remaininghours = hours - days * 24
        if remaininghours > 0 {
            shortString += ("\(remaininghours)" + NELocalize.localizedString("randomgift_lastprize_hour", comment: ""))
        }
        let remainingmin = min - hours * 60
        if min > 0 {
            shortString += ("\(remainingmin)" + NELocalize.localizedString("randomgift_lastprize_minute", comment: ""))
        }
        return shortString
    }
    
    public func toShortString() -> String {
        let min = Int(floor(self / 60))
        let hours = min / 60
        let days = hours / 24
        let weeks = days / 7

        let shortString: String
        if weeks > 0 {
            shortString = NELocalize.localizedString(NSString(format: "%dw", weeks) as String, comment: "")
        } else if days > 0 {
            shortString = NELocalize.localizedString(NSString(format: "%dd", days) as String, comment: "")
        } else if hours > 0 {
            shortString = NELocalize.localizedString(NSString(format: "%dh", hours) as String, comment: "")
        } else if min > 0 {
            shortString = NELocalize.localizedString(NSString(format: "%dm", min) as String, comment: "")
        } else {
            shortString = NELocalize.localizedString(NSString(format: "%ds", self) as String, comment: "")
        }

        return shortString
    }
    
    public func getTimeByFormerly(farmat: String? = nil) -> String {
        if self == 0 {
            return ""
        }
        let dateTime = Date().timeIntervalSince1970
        let subDate = dateTime - self
        if subDate <= 3600 {
            let minutes = subDate / 60
            if minutes < 2 {
                return "1\(NELocalize.localizedString("minute ago", comment: ""))"
            }
            return "\(Int(minutes))\(NELocalize.localizedString("minutes ago", comment: ""))"
        } else if (subDate > 3600 && subDate <= 86400) {
            let hours = subDate / 3600
            if hours < 2 {
                return "1\(NELocalize.localizedString("hour ago", comment: ""))"
            }
            return "\(Int(hours))\(NELocalize.localizedString("hours ago", comment: ""))"
        } else if (subDate > 86400 && subDate <= 2592000) {
            let days = subDate / 86400
            if days < 2 {
                return "1\(NELocalize.localizedString("day ago", comment: ""))"
            }
            return "\(Int(days))\(NELocalize.localizedString("days ago", comment: ""))"
        }
        let dateFormatter = DateFormatter()
        if let farmat = farmat {
            dateFormatter.setLocalizedDateFormatFromTemplate(farmat)
        } else {
            dateFormatter.setLocalizedDateFormatFromTemplate("yyyy.MM.dd")
        }
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    public func getTimeByFuture(farmat: String? = nil, isDiffContry: Bool = false) -> String {
        if self == 0 {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strNow = dateFormatter.string(from: Date())
        let strSelf = dateFormatter.string(from: Date(timeIntervalSince1970: self))
        
        guard let dateNow = dateFormatter.date(from: strNow), let dateSelf = dateFormatter.date(from: strSelf) else {
            return ""
        }
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year,.month, .day], from: dateNow, to: dateSelf)
        if dateComponents.year == 0, dateComponents.month == 0 {
            if dateComponents.day == 0 {
                return isDiffContry ? LocalizedService.eventOperationString("today", "") : String(format: NELocalize.localizedString("today", comment: ""), "")
            } else if dateComponents.day == 1 {
                return isDiffContry ? LocalizedService.eventOperationString("tommorrow", "") : String(format: NELocalize.localizedString("tommorrow", comment: ""), "")
            }
        }
        let formatter = DateFormatter()
        if let farmat = farmat {
            formatter.setLocalizedDateFormatFromTemplate(farmat)
        } else {
            formatter.setLocalizedDateFormatFromTemplate("yyyy.MM.dd")
        }
        return formatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    
    // MARK: 倒计时格式
    
    // 返回"00:00"格式的倒计时
    public func getCommonCountDownFormat() -> String {
        let minutes: Int = Int(self/60)
        let seconds: Int = Int(self - TimeInterval(minutes*60))
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // 返回"1分20秒"格式的倒计时
    public func getCommonCountDownFormat2() -> String {
        let minutes: Int = Int(self/60)
        let seconds: Int = Int(self - TimeInterval(minutes*60))
        if minutes > 0 {
            return String(format: "%d%@%d%@", minutes, NELocalize.localizedString("randomgift_lastprize_minute"), seconds, NELocalize.localizedString("randomgift_lastprize_second"))
        } else {
            return String(format: "%d%@", seconds, NELocalize.localizedString("randomgift_lastprize_second"))
        }
    }
    
    // 用于通话记录的拨打时间
    // 规则：
    // 如果是今天显示 昨天 HH:mm
    // 如果是昨天显示 昨天 HH:mm
    // 如果是前天显示 昨天 HH:mm
    // 如果是本周显示 星期一 HH:mm
    // 如果是本年显示 05-05 HH:mm
    // 如果是往年显示 2018-05-05 HH:mm
    public func p2pCallRecordCallTimeFormat() -> String {
        if self == 0 {
            return ""
        }
        
        var prefixStr: String = ""
        
        let dateNow = Date()
        let dateSelf = Date(timeIntervalSince1970: self)
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(dateSelf) {
            // 是今天
            prefixStr = NELocalize.localizedString("call_history_time_today", comment: "")
            if prefixStr == "" {
                prefixStr = LocalizedService.eventOperationString("call_history_time_today", "")
            }
        } else if calendar.isDateInYesterday(dateSelf) {
            // 是昨天
            prefixStr = NELocalize.localizedString("call_history_time_yesterday", comment: "")
            if prefixStr == "" {
                prefixStr = LocalizedService.eventOperationString("call_history_time_yesterday", "")
            }
        } else if calendar.isDateInWeekend(dateSelf) {
            // 是同一周
            prefixStr = dateSelf.getWeekDayName() ?? ""
        } else {
            // 判断是否同年
            let dateComponents = calendar.dateComponents([.year,.month, .day], from: dateNow, to: dateSelf)
            if dateComponents.year == 0 {
                // 同年
                prefixStr = dateSelf.string(withFormat: "MM-dd")
            } else {
                // 往年
                prefixStr = dateSelf.string(withFormat: "yyyy-MM-dd")
            }
        }
        
        let suffixStr: String = dateSelf.string(withFormat: "HH:mm")
        let resultStr: String = prefixStr + " " + suffixStr
        
        return resultStr
    }
    
    // 返回"00:00:00"格式的倒计时
    public func hhmmss() -> String {
        if self <= 0 {
            return "00:00:00"
        }
        let hours: Int = Int(self / 3600)
        let minutes: Int = Int(self / 60 - TimeInterval(hours*60))
        let seconds: Int = Int(self - TimeInterval(hours*3600) - TimeInterval(minutes*60))
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    public func getHomeActivityRemainTimeFormat() -> String {
        if self == 0 {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let oneDaySec: TimeInterval = 24.0 * 60.0 * 60.0
        var days: Int = 0
        var remainSec: TimeInterval = 0
        if self > oneDaySec {
            days = Int(self/oneDaySec)
            remainSec = self - TimeInterval(days) * oneDaySec
        } else {
            remainSec = self
            if remainSec < 0 {
                remainSec = 0
            }
        }
        
        let remainString = dateFormatter.string(from: Date.init(timeIntervalSince1970: remainSec))
        
        return String(format:NELocalize.localizedString("hot_tab_act_time"), "\(days)", remainString)
    }
    
    //获取当天0点时间戳,是utc时间的0点,self必须是utc的0点之后，不然会获取前一天时间
    public func getThisDayZero(offset:TimeInterval = 0) -> TimeInterval {
        let days = Int64(self - offset) / Int64(24 * 60 * 60)
        let leftTime = TimeInterval(days) * TimeInterval(24 * 60 * 60)
        return leftTime + offset
    }
}
