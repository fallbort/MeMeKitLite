//
//  MMNotificationProtocol.swift
//  LinYu
//
//  Created by xfb on 2023/8/16.
//

import Foundation
import Foundation
import MeMeKit

public protocol MMNotificationProtocol {
    associatedtype NotificationName: RawRepresentable
}

extension MMNotificationProtocol where NotificationName.RawValue == String {

    // MARK: - Static Computed Variables

    fileprivate static func nameFor(_ notification: NotificationName) -> String {
        return "\(self).\(notification.rawValue)"
    }

    // MARK: - Static Function

    // Post
    public static func post(_ notification: NotificationName, object: Any? = nil, userInfo: [String : Any]? = nil) {
        let name = NSNotification.Name(rawValue: nameFor(notification))
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }

    // Add
    public static func addObserver(_ observer: Any, selector: Selector, notification: NotificationName) {
        let name = NSNotification.Name(rawValue: nameFor(notification))
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
    }

    // Remove
    public static func removeObserver(_ observer: Any, notification: NotificationName? = nil, object: Any? = nil) {
        guard let notification = notification else {
            NotificationCenter.default.removeObserver(observer)
            return
        }
        let name = NSNotification.Name(rawValue: nameFor(notification))
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
    }

}
