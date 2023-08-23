//
//  FrameObserView.swift
//  MeMeKit
//
//  Created by fabo on 2022/8/12.
//

import Foundation

import Foundation
import Cartography
import MeMeKit

public class FrameObserView : TranslateHitView {
    public var didBoundsChangedBlock:((_ bounds:CGRect)->())?
    
    public var didMovedToSuperViewBlock:VoidBlock?
    
    public override var bounds: CGRect{
        didSet{
            guard bounds != oldValue else {return}
            didBoundsChangedBlock?(bounds)
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.didMovedToSuperViewBlock?()
    }
}
