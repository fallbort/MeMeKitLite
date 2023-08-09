//
//  MMIdentity.swift
//  MeMeKit
//
//  Created by xfb on 2023/8/9.
//

import Foundation

public protocol MMIdentity: Equatable {
    var id: Int { get set }
    init()
    init(id: Int)
}

extension MMIdentity {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
