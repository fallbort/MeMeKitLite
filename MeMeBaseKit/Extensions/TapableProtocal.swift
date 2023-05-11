//
//  TapableProtocal.swift
//  MeMe
//
//  Created by admin on 2019/11/12.
//  Copyright © 2019 sip. All rights reserved.
//

public protocol SubviewActionable {
    
}

extension SubviewActionable where Self:UIView {
    func hasActionable() -> Bool {
        if self.isUserInteractionEnabled == true {
            if let recognizers = self.gestureRecognizers,recognizers.count > 0 {
                return true
            }
        }
        
        return false
    }
}

extension UIView {
    public func findCanActionableSubviews(view:UIView? = nil,justOne:Bool = true) -> [UIView]? {
        var array:[UIView]? = nil
        if let view = view == nil ? self : view {
            for (i,item) in view.subviews.enumerated() {
                if let item = item as? SubviewActionable&UIView {
                    if item.hasActionable(){
                        if array == nil {array = []}
                        array?.append(item)
                        if justOne {
                            return array
                        }
                    }else{
                        if let newArray = self.findCanActionableSubviews(view:item,justOne: justOne) {
                            if array == nil {array = []}
                            array?.append(contentsOf: newArray)
                            if justOne == true && array!.count > 0 {
                                return array
                                
                            }
                        }
                    }
                }else{
                    if let newArray = self.findCanActionableSubviews(view:item,justOne: justOne) {
                        if array == nil {array = []}
                        array?.append(contentsOf: newArray)
                        if justOne == true && array!.count > 0 {
                            return array
                            
                        }
                    }
                }
            }
        }
        
        return array
    }
}
