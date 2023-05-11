//
//  Array+Extensions.swift
//
//  Created by Solomon English on 11/10/15.
//  Copyright © 2015 FunPlus. All rights reserved.
//

import Foundation
import Dispatch

private var semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)

extension ArraySlice {
    public func indexOf(_ includedElement: (Element) -> Bool) -> Int? {
        for (idx, element) in self.enumerated() {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
}

extension Array {
    public func indexOf(_ includedElement: (Element) -> Bool) -> Int? {
        for (idx, element) in self.enumerated() {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
	
	public func itemAtIndex(_ index: Int) -> Element? {
		if self.count > index {
			return self[index]
		}
		
		return nil
	}
    
    public func itemAtOf(_ includedElement: (Element) -> Bool) -> Element? {
        for element in self {
            if includedElement(element) {
                return element
            }
        }
        return nil
    }
    
    public func toJsonString() -> String? {
        do {
            let jsondata = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            
            let str = NSString.getFromNoCrash(jsondata, encoding: String.Encoding.utf8.rawValue) as String?
            return str
        } catch let error {
//            log.verbose("\(error)")
            return nil
        }
    }
    
    @discardableResult
    public mutating func safeRemoveFirst() -> Element?  {
        if self.count > 0 {
            return self.removeFirst()
        }else{
            return nil
        }
    }
}

extension Array where Element: Comparable {
    private mutating func merge(lo: Int, mi: Int, hi: Int) {
        var tmp: [Element] = []
        var i = lo, j = mi
        while i != mi && j != hi{
            if self[j] < self[i] {
                tmp.append(self[j])
                j += 1
            }else{
                tmp.append(self[i])
                i += 1
            }
        }
        tmp.append(contentsOf: self[i..<mi])
        tmp.append(contentsOf: self[j..<hi])
        replaceSubrange(lo..<hi, with: tmp)
    }
}

extension Array where Element: Equatable {
    
    public mutating func enqueue(of element: Element) {
        semaphore.wait()
        append(element)
        semaphore.signal()
    }
    
    public mutating func dequeue(of element: Element) -> Element? {
        if let index = indexOf({ $0 == element }) {
            semaphore.wait()
            let e = remove(at: index)
            semaphore.signal()
            return e
        } else {
            return nil
        }
    }
    
    typealias SortDescriptor<Value> = (Value, Value) -> Bool
    static func combine<Value>(sortDescriptors: [SortDescriptor<Value>]) -> SortDescriptor<Value> {
        return { lhs, rhs in
            for areInIncreasingOrder in sortDescriptors {
                if areInIncreasingOrder(lhs,rhs) {return true}
                if areInIncreasingOrder(rhs,lhs) {return false}
            }
            return false
        }
    }
    
    static func sortDescriptor<Value, Key>(key: @escaping (Value) -> Key,
                                           ascending: Bool = true,
                                           by comparator: @escaping (Key) -> (Key) -> ComparisonResult) -> SortDescriptor<Value>
    {
        return { lhs, rhs in
            let order: ComparisonResult = ascending ? .orderedAscending : .orderedDescending
            return comparator(key(lhs))(key(rhs)) == order
        }
    }
    
    func lift<A>(_ compare: @escaping (A) -> (A) -> ComparisonResult) -> (A?) -> (A?) -> ComparisonResult {
        return{lhs in{ rhs in
            switch (lhs, rhs) {
            case (nil, nil): return .orderedSame
            case (nil, _): return .orderedAscending
            case (_, nil): return .orderedDescending
            case let (l?, r?): return compare(l)(r)
            }
        }}
    }
    
}

extension Array {
    public func fetchTypeObject<T>(_ type: T.Type) -> T? {
        return self.first(where:{$0 is T}) as? T
    }
}

extension Array where Element == UInt {
    public func mapUids() -> [Int] {
        let newUids:[Int] = self.map({ uid in
            return Int(uid)
        })
        return newUids
    }
    
    public func mapUids() -> [UInt] {
        return self
    }
}

extension Array where Element == UInt? {
    public func mapUids() -> [Int?] {
        let newUids:[Int?] = self.map({ uid in
            if let uid = uid {
                return Int(uid)
            }
            return nil
        })
        return newUids
    }
    
    public func mapUids() -> [UInt?] {
        return self
    }
}

extension Array where Element == Int {
    public func mapUids() -> [UInt] {
        let newUids:[UInt] = self.map({ uid in
            return UInt(uid)
        })
        return newUids
    }
    
    public func mapUids() -> [Int] {
        return self
    }
}

extension Array where Element == Int? {
    public func mapUids() -> [UInt?] {
        let newUids:[UInt?] = self.map({ uid in
            if let uid = uid {
                return UInt(uid)
            }
            return nil
        })
        return newUids
    }
    
    public func mapUids() -> [Int?] {
        return self
    }
}
