//
//  HeaderView.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/12.
//

import UIKit

class HeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBInspectable var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
}
