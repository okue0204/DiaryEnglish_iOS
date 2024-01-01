//
//  HeaderView.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/12.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func didDiarySave()
    func didClose()
}

extension HeaderViewDelegate {
    func didDiarySave() {}
    func didClose() {}
}

class HeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
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
    
    @IBInspectable var isShowCloseButton: Bool {
        get {
            closeButton.isHidden
        }
        set {
            closeButton.isHidden = !newValue
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
    
    @IBAction func didClose(_ sender: Any) {
        delegate?.didClose()
    }
}
