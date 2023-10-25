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
    
    func updateLayout(tab: Tab) {
        stackView.subviews.forEach { view in
            let selectColor = view.tag == tab.rawValue ? UIColor.systemPink : .black
            view.subviews.forEach {
                if let imageView = $0 as? UIImageView {
                    imageView.tintColor = selectColor
                }
            }
        }
    }
    
    private func selectTab(tabType: Tab) {
        let old = selectTab
        selectTab = tabType
        delegate?.tabDidSelect(selectTab: selectTab, oldTab: old)
    }
    
    @IBAction func homeButtonDidTap(_ sender: Any) {
        updateLayout(tab: .home)
        selectTab(tabType: .home)
    }
    
    @IBAction func addDiaryButtonDidTap(_ sender: Any) {
        updateLayout(tab: .addDiary)
        selectTab(tabType: .addDiary)
    }
    
    @IBAction func settingButtonDidTap(_ sender: Any) {
        updateLayout(tab: .setting)
        selectTab(tabType: .setting)
    }
}
