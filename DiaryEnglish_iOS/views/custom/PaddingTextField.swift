//
//  PaddingTextField.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/26.
//

import UIKit

class PaddingTextField: UITextField {
    
    @IBInspectable var topPadding: CGFloat = 0
    @IBInspectable var bottomPadding: CGFloat = 0
    @IBInspectable var leftPadding: CGFloat = 16
    @IBInspectable var rightPadding: CGFloat = 16
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topPadding,
                                             left: leftPadding,
                                             bottom: bottomPadding,
                                             right: rightPadding))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topPadding,
                                             left: leftPadding,
                                             bottom: bottomPadding,
                                             right: rightPadding))
    }
}
