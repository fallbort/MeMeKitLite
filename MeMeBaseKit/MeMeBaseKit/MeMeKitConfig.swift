//
//  MeMeKitConfig.swift
//  MeMeKit
//
//  Created by fabo on 2022/4/12.
//

import Foundation

@objc public class MeMeKitConfig : NSObject {
    @objc public static let shared:MeMeKitConfig = MeMeKitConfig()
    //MARK:<>外部变量
    
    //MARK:<>外部block
    @objc public enum MeMeKitImageType : Int {
        case normal = 1 //
        case IM = 2
    }
    @objc public enum MeMeKitLocalizeType : Int {
        case normal = 1 //
        case IM = 2 //imtable的多语言
    }
    @objc public static var imageIconBlock:((String,MeMeKitImageType)->UIImage?) = {_,_ in return nil} //显示图片
    @objc public static var localizeStringBlock:((String,MeMeKitLocalizeType)->String) = {str,_ in return str} //显示多语言
    @objc public static var converCDNBlock:((String)->String) = {url in return url} //cdn转换后的url
    @objc public static var converH5Block:((String)->URL?) =  {url in return URL(string: url)} //h5转换后的url
    @objc public static var showHUDBlock:((_ message:String)->()) = {_ in return} //显示toast
    
    @objc public static var userIdBlock:(()->Int) = {return 0} //userId
    
    
    //MARK:<>生命周期开始
    private override init() {super.init()}
    //MARK:<>功能性方法
    
    //MARK:<>内部View
    
    //MARK:<>内部UI变量
    //MARK:<>内部数据变量
    
    //MARK:<>内部block
    
}
