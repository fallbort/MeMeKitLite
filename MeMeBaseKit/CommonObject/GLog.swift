//
//  GLog.swift
//  MeMeKit
//
//  Created by fabo on 2023/3/6.
//

import Foundation

/// 打印日志
///
/// - Parameters:
///   - message: 内容
///   - filePath: 文件名
///   - rowCount: 所在文件位置
public func gLog<content>(_ message: content, filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
    let fieldName = (filePath as NSString).lastPathComponent.replacingOccurrences(of:".swift", with:"")
    print("MeMe Log--" + getLogTimeNow())
    print("MeMe Log--" + "["+fieldName+":"+"(\(rowCount))" + "]")
    print("MeMe Log--" + "\(message)"+"\n")
    #endif
}

private func getLogTimeNow()-> String{
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let stringDate = dateFormatter.string(from: currentDate)
    return stringDate
    
}
