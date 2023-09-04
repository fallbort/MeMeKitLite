//
//  ThemeBase.swift
//  MeMeKit
//
//  Created by fabo on 2023/3/7.
//

import Foundation

@objc public class ThemeLite : NSObject {
    @objc public class Font : NSObject {
        public class func medium(size: CGFloat) -> UIFont {
            return self.medium(size: size, overrideWeight: .medium)
        }
        
        public class func light(size: CGFloat) -> UIFont {
            return self.light(size: size, overrideWeight: .light)
        }
        
        public class func regular(size: CGFloat) -> UIFont {
            return self.regular(size: size, overrideWeight: .regular)
        }
        
        public class func bold(size: CGFloat) -> UIFont {
            return self.bold(size: size, overrideWeight: .bold)
        }
        
        // 自定义字体
        public class func fzCuYuan(size: CGFloat) -> UIFont {
            if let font = UIFont(name: "FZCuYuan-M03", size: size) {
                return font
            } else {
                return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
            }
        }
        
        @objc public class func pingfang(size: CGFloat,weight:UIFont.Weight = .regular) -> UIFont {
            if weight == .medium, let font = UIFont(name: "PingFangSC-Medium", size: size) {
                return font
            } else if weight != .medium, let font = UIFont(name: "PingFangSC-Regular", size: size) {
                return font
            } else {
                return self.regular(size: size)
            }
        }
        
        @objc public class func bebasNeueRegular(size: CGFloat) -> UIFont {
            if let font = UIFont(name: "BebasNeue-Regular", size: size) {
                return font
            } else {
                return self.regular(size: size)
            }
        }
    }
}

extension ThemeLite.Font {
    
    public enum FontWeight: String {
        case ultraLight = "ultraLight"
        case thin = "thin"
        case light = "light"
        case regular = "regular"
        case medium = "medium"
        case semibold = "semibold"
        case bold = "bold"
        case heavy = "heavy"
        case black = "black"
        
        var weight: UIFont.Weight {
            switch self {
            case .ultraLight:
                return UIFont.Weight.ultraLight
            case .thin:
                return UIFont.Weight.thin
            case .light:
                return UIFont.Weight.light
            case .regular:
                return UIFont.Weight.regular
            case .medium:
                return UIFont.Weight.medium
            case .semibold:
                return UIFont.Weight.semibold
            case .bold:
                return UIFont.Weight.bold
            case .heavy:
                return UIFont.Weight.heavy
            case .black:
                return UIFont.Weight.black
            }
        }
    }
    
    // bold
    public class func bold(size: CGFloat, overrideWeight: FontWeight) -> UIFont {
        // 英文系统，使用重载的"字重"
        if LanguageService.currentLanguageCode == "en" {
            return UIFont.systemFont(ofSize: size, weight: overrideWeight.weight)
        }

        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }
    
    // regular
    public class func regular(size: CGFloat, overrideWeight: FontWeight) -> UIFont {
        // 英文系统，使用重载的"字重"
        if LanguageService.currentLanguageCode == "en" {
            return UIFont.systemFont(ofSize: size, weight: overrideWeight.weight)
        }
        
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    // medium
    public class func medium(size: CGFloat, overrideWeight: FontWeight) -> UIFont {
        // 英文系统，使用重载的"字重"
        if LanguageService.currentLanguageCode == "en" {
            return UIFont.systemFont(ofSize: size, weight: overrideWeight.weight)
        }

        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }
    
    // light
    public class func light(size: CGFloat, overrideWeight: FontWeight) -> UIFont {
        // 英文系统，使用重载的"字重"
        if LanguageService.currentLanguageCode == "en" {
            return UIFont.systemFont(ofSize: size, weight: overrideWeight.weight)
        }
  
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
    }
}



