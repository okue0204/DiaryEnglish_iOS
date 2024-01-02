//
//  HeaderView.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/12.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func didDiarySave()
}

class HeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: HeaderViewDelegate?
    
    @IBInspectable var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    @IBInspectable var isShowSaveButton: Bool {
        get {
            saveButton.isHidden
        }
        set {
            saveButton.isHidden = !newValue
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
    
    @IBAction func didDiarySave(_ sender: Any) {
        delegate?.didDiarySave()
    }
}
