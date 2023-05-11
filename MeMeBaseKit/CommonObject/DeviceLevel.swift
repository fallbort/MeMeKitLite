//
//  DeviceLevel.swift
//  MeMe
//
//  Created by Mingde on 2018/8/20.
//  Copyright © 2018 sip. All rights reserved.
//
//

import MeMeKit
import Foundation

public enum DeviceLevelType: String {
    case Low                = "low"
    case Default            = "default"
    case High               = "high"
    case Default_zip        = "default_zip"
    case Low_zip        = "low_zip"
    case High_zip        = "high_zip"
}

public var HardwareDeviceLevel: DeviceLevelType = .Default
public var HardwareDeviceLevelZip: DeviceLevelType = .Default_zip

public class DeviceLevel {
    public class func getHardwareDeviceLevel() -> DeviceLevelType {
        
        // 低端
        if  Device.version() == .iPhone4         ||
            Device.version() == .iPhone4S        ||
            Device.version() == .iPhone5         ||
            Device.version() == .iPhone5C        ||
            Device.version() == .iPhone5S        ||
            Device.version() == .iPhoneSE        ||
            
            Device.version() == .iPodTouch1Gen   ||
            Device.version() == .iPodTouch2Gen   ||
            Device.version() == .iPodTouch3Gen   ||
            Device.version() == .iPodTouch4Gen   ||
            Device.version() == .iPodTouch5Gen   ||
            
            Device.version() == .iPad1           ||
            Device.version() == .iPad2           ||
            Device.version() == .iPad3           ||
            Device.version() == .iPad4           ||
            Device.version() == .iPad5           ||
            
            Device.version() == .iPadAir         ||
            Device.version() == .iPadAir2        ||
            Device.version() == .iPadMini        ||
            Device.version() == .iPadMini2
        {
            HardwareDeviceLevel = .Low
            return .Low
        }
        
        // 中端
        if  Device.version() == .iPhone6         ||
            Device.version() == .iPhone6Plus     ||
            Device.version() == .iPhone6S        ||
            Device.version() == .iPhone6SPlus    ||
            
            Device.version() == .iPodTouch6Gen   ||
            Device.version() == .iPadMini4       ||
            Device.version() == .simulator  
        {
            HardwareDeviceLevel = .Default
            return .Default
        }
        
        // 高端，上面覆盖了目前市面上所有的，后续的iOS设备都会好于上面的，为了体验iOS的默认采用高画质。
        HardwareDeviceLevel = .High
        return .High
    }
    
    public class func getHardwareDeviceLevel_zip() -> DeviceLevelType {
        
        // 低端
        if  Device.version() == .iPhone4         ||
            Device.version() == .iPhone4S        ||
            Device.version() == .iPhone5         ||
            Device.version() == .iPhone5C        ||
            Device.version() == .iPhone5S        ||
            Device.version() == .iPhoneSE        ||
            
            Device.version() == .iPodTouch1Gen   ||
            Device.version() == .iPodTouch2Gen   ||
            Device.version() == .iPodTouch3Gen   ||
            Device.version() == .iPodTouch4Gen   ||
            Device.version() == .iPodTouch5Gen   ||
            
            Device.version() == .iPad1           ||
            Device.version() == .iPad2           ||
            Device.version() == .iPad3           ||
            Device.version() == .iPad4           ||
            Device.version() == .iPad5           ||
            
            Device.version() == .iPadAir         ||
            Device.version() == .iPadAir2        ||
            Device.version() == .iPadMini        ||
            Device.version() == .iPadMini2
        {
            HardwareDeviceLevelZip = .Low_zip
            return .Low_zip
        }
        
        // 中端
        if  Device.version() == .iPhone6         ||
            Device.version() == .iPhone6Plus     ||
            Device.version() == .iPhone6S        ||
            Device.version() == .iPhone6SPlus    ||
            
            Device.version() == .iPodTouch6Gen   ||
            Device.version() == .iPadMini4       ||
            Device.version() == .simulator
        {
            HardwareDeviceLevelZip = .Default_zip
            return .Default_zip
        }
        
        // 高端，上面覆盖了目前市面上所有的，后续的iOS设备都会好于上面的，为了体验iOS的默认采用高画质。
        HardwareDeviceLevelZip = .High_zip
        return .High_zip
    }
}
