//
//  FooterView.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/24.
//

import UIKit

protocol FooterViewDelegate: AnyObject {
    func tabDidSelect(selectTab: Tab, oldTab: Tab)
}

class FooterView: UIView {
    
    @IBOutlet weak var homeButtonImageView: UIImageView!
    @IBOutlet weak var addDiaryImageView: UIImageView!
    @IBOutlet weak var settingButtonImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var addDiaryLabel: UILabel!
    @IBOutlet weak var settingLabel: UILabel!
    
    weak var delegate: FooterViewDelegate?
    
    private var selectTab: Tab = .home {
        didSet {
            if selectTab == oldValue {
                return
            }
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
    
    private func updateLayout(selectTab: Tab, oldTab: Tab) {
        stackView.subviews.forEach { view in
            let selectColor = view.tag == selectTab.rawValue ? UIColor.systemPink : .lightGray
            view.subviews.forEach {
                if let label = $0 as? UILabel {
                    label.textColor = selectColor
                } else if let imageView = $0 as? UIImageView {
                    if view.tag == selectTab.rawValue {
                        imageView.image = selectTab.imageFil
                    } else if view.tag == oldTab.rawValue {
                        imageView.image = oldTab.image
                    }
                    imageView.tintColor = selectColor
                }
            }
        }
    }
    
    func selectTab(tabType: Tab) {
        let old = selectTab
        selectTab = tabType
        updateLayout(selectTab: selectTab, oldTab: old)
        delegate?.tabDidSelect(selectTab: selectTab, oldTab: old)
    }
    
    @IBAction func homeButtonDidTap(_ sender: Any) {
        selectTab(tabType: .home)
    }
    
    @IBAction func addDiaryButtonDidTap(_ sender: Any) {
        selectTab(tabType: .addDiary)
    }
    
    @IBAction func settingButtonDidTap(_ sender: Any) {
        selectTab(tabType: .setting)
    }
}
