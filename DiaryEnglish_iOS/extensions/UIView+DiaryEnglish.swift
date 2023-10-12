//
//  UIView+DiaryEnglish.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/12.
//

import Foundation
import UIKit

extension UIView {
    
    @discardableResult
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let view = UINib(nibName: String(describing: Self.self), bundle: bundle).instantiate(withOwner: self).first as! UIView
        addSubview(view)
        view.sameToPosition(view: self)
        return view
    }
    
    func sameToPosition(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}
