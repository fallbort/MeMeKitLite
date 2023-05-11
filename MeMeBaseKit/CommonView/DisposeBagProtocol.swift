//
//  DisposeBagProtocol.swift
//  MeMeKit
//
//  Created by fabo on 2022/5/26.
//

import UIKit
import RxSwift

public protocol DisposeBagProtocol : AnyObject {
    var mmDisposeBag: DisposeBag {get set}
}

private var DisposeBag_mmDisposeBag = "DisposeBag_mmDisposeBag"

extension DisposeBagProtocol {
    public var mmDisposeBag: DisposeBag {
        get {
            if let object = objc_getAssociatedObject(self, &DisposeBag_mmDisposeBag) as? DisposeBag {
                return object
            }else {
                let bag = DisposeBag()
                objc_setAssociatedObject(self, &DisposeBag_mmDisposeBag, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return bag
            }
        }
        
        set {
            objc_setAssociatedObject(self, &DisposeBag_mmDisposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension NSObject : DisposeBagProtocol {
    
}
 
