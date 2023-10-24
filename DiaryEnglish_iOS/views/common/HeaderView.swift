//
//  HeaderView.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/12.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func backButtonDidTap()
    func settingButtonDidTap()
    func deleteButtonDidTap()
    func defaultButtonDidTap()
}

extension HeaderViewDelegate {
    func backButtonDidTap() {}
    func settingButtonDidTap() {}
    func deleteButtonDidTap() {}
    func defaultButtonDidTap() {}
}

class HeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var defaultButton: UIButton!
    
    weak var delegate: HeaderViewDelegate?
    
    @IBInspectable var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    @IBInspectable var isShowBackButton: Bool {
        get {
            backButton.isHidden
        }
        set {
            backButton.isHidden = !newValue
        }
    }
    
    @IBInspectable var isShowsettingButton: Bool {
        get {
            settingButton.isHidden
        }
        set {
            settingButton.isHidden = !newValue
        }
    }
    
    @IBInspectable var isShowDeleteButton: Bool {
        get {
            deleteButton.isHidden
        }
        set {
            deleteButton.isHidden = !newValue
        }
    }
    
    @IBInspectable var isShowDefaultButton: Bool {
        get {
            defaultButton.isHidden
        }
        set {
            defaultButton.isHidden = !newValue
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
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        delegate?.backButtonDidTap()
    }
    
    @IBAction func settingButtonDidTap(_ sender: Any) {
        delegate?.settingButtonDidTap()
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        delegate?.deleteButtonDidTap()
    }
    
    @IBAction func defaultButtonDidTap(_ sender: Any) {
        delegate?.defaultButtonDidTap()
    }
}
