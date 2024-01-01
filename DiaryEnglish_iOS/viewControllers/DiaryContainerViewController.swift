//
//  DiaryContainerViewController.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/24.
//

import UIKit

class DiaryContainerViewController: UIViewController {
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var containerView: UIView!
    
    private lazy var viewControllers: [UIViewController] = [
        UIStoryboard.diaryListViewController.instantiateInitialViewController()!,
        UIStoryboard.diaryEditViewControllerStoryboard.instantiateInitialViewController()!,
        UIStoryboard.settingViewControllerStoryboard.instantiateInitialViewController()!
    ]
    
    var selectTab: Tab = .home

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    private func setupLayout() {
        headerView.delegate = self
        headerView.isShowSaveButton = false
        headerView.isShowCloseButton = false
        footerView.delegate = self
        changeViewController(selectTab: .home)
    }
    
    private func changeViewController(selectTab: Tab, oldTab: Tab? = nil) {
        guard selectTab != oldTab else {
            return
        }
        self.selectTab = selectTab
        containerView.subviews.forEach { $0.removeFromSuperview() }
        let viewController = viewControllers[selectTab.rawValue]
        if let diaryEditViewController = viewController as? DiaryEditViewController {
            diaryEditViewController.transitionType = .register
            diaryEditViewController.delegate = self
        }
        footerView.selectTab(tabType: selectTab)
        headerView.title = selectTab.title
        addChild(viewController)
        containerView.frame = viewController.view.bounds
        containerView.addSubview(viewController.view)
        didMove(toParent: self)
    }
}

extension DiaryContainerViewController: FooterViewDelegate {
    func tabDidSelect(selectTab: Tab, oldTab: Tab) {
        changeViewController(selectTab: selectTab, oldTab: oldTab)
    }
}

extension DiaryContainerViewController: HeaderViewDelegate {
    func didDiarySave() {
        if let diaryEditViewController = viewControllers[selectTab.rawValue] as? DiaryEditViewController {
            diaryEditViewController.transitionType = .register
            diaryEditViewController.dairyDataSave()
        }
    }
}

extension DiaryContainerViewController: DiaryEditViewControllerDelegate {
    func didDiaryUpdate() {
        changeViewController(selectTab: .home)
    }
}
