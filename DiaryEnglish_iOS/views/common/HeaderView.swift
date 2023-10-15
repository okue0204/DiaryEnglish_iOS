//
//  HeaderView.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/12.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func backButtonDidTap()
    func deleteButtonDidTap()
}

extension HeaderViewDelegate {
    func backButtonDidTap() {}
    func deleteButtonDidTap() {}
}

class HeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
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
    
    @IBInspectable var isShowDeleteButton: Bool {
        get {
            deleteButton.isHidden
        }
        set {
            deleteButton.isHidden = !newValue
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
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        delegate?.deleteButtonDidTap()
    }
}
