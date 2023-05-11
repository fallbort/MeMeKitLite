//
//  FetchTypeProtocol.swift
//  MeMeKit
//
//  Created by fabo on 2022/5/18.
//

import Foundation

public protocol FetchTypeProtocol {
    
}
extension FetchTypeProtocol {
    public func fetchType() -> Self.Type {
        return type(of: self)
    }
}
