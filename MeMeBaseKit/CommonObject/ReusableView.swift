//
//  ReusableView.swift
//  MeMe
//
//  Created by LuanMa on 16/9/5.
//  Copyright © 2016年 sip. All rights reserved.
//

public protocol ReusableView: class {
}

extension ReusableView where Self: UIView {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView { }
extension UITableViewHeaderFooterView: ReusableView { }
extension UICollectionReusableView: ReusableView { }
extension UICollectionViewCell: ReusableView { }

extension UITableView {
    public func registerClass<T: UITableViewCell>(_ cellClass: T.Type, xib: Bool = false) {
        if xib == true {
            let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
            register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        }else {
            register(cellClass, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ cellClass: T.Type, xib: Bool) {
        if xib == true {
            let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
            register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }else {
            register(cellClass, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(_: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    public func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(_: T.Type) -> T {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue headerfooter with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    public func dequeueReusableCell<T: UITableViewCell>() -> T? {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T
    }
}

extension UICollectionView {
    public func registerClass<T: UICollectionViewCell>(_ cellClass: T.Type, xib: Bool = false, reuseIdentifier: String? = nil) {
        if xib == true {
            let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: T.reuseIdentifier + (reuseIdentifier ?? ""))
        }else {
            register(cellClass, forCellWithReuseIdentifier: T.reuseIdentifier + (reuseIdentifier ?? ""))
        }
    }
    
    public func registerHeaderFooter<T: UICollectionReusableView>(_ cellClass: T.Type, kind: String, xib: Bool = true) {
      if xib == true {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
      }else {
        register(cellClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
      }
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath, reuseIdentifier: String? = nil) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier + (reuseIdentifier ?? ""), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(_: T.Type, forIndexPath indexPath: IndexPath, reuseIdentifier: String? = nil) -> T {
      guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier + (reuseIdentifier ?? ""), for: indexPath) as? T else {
        fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier + (reuseIdentifier ?? ""))")
      }
      
      return cell
    }
    
    public func dequeueReusableHeaderFooter<T: UICollectionReusableView>(_: T.Type, kind: String, indexPath: IndexPath) -> T {
      
      guard let header = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
        fatalError("Could not dequeue SupplementaryView with identifier: \(T.reuseIdentifier)")
      }
      return header
    }
}
