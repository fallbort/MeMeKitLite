//
//  FUNKeyboardObserver.swift
//  LiveCap
//
//  Created by LuanMa on 16/3/3.
//  Copyright © 2016年 FunPlus. All rights reserved.
//

import UIKit

public class FUNKeyboardObserver: NSObject {
	fileprivate let _tableView: UITableView

	public init(tableView: UITableView) {
		_tableView = tableView

		super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(FUNKeyboardObserver.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FUNKeyboardObserver.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Keyboard Notifications

    @objc func keyboardDidShow(_ notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
			updateTableView(_tableView, withBottomInset: keyboardSize.height)
		}
	}

    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
		updateTableView(_tableView, withBottomInset: 0)
	}

	public func updateTableView(_ tableView: UITableView, withBottomInset bottomInset: CGFloat) {
		let contentOffset = tableView.contentOffset
        let contentInsets = UIEdgeInsets(top: _tableView.contentInset.top, left: _tableView.contentInset.left, bottom: min(_tableView.contentInset.bottom + bottomInset, bottomInset), right: _tableView.contentInset.right)

		tableView.contentInset = contentInsets
		tableView.contentOffset = contentOffset
	}
}
