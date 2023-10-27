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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    private func setupLayout() {
        headerView.delegate = self
        changeViewController(selectTab: .home)
        footerView.updateLayout(tab: .home)
        footerView.delegate = self
        BackgroundAnimationManager.setupAnimation(view: view)
    }
    
    private func changeViewController(selectTab: Tab, oldTab: Tab? = nil) {
        guard selectTab != oldTab else {
            return
        }
        containerView.subviews.forEach { $0.removeFromSuperview() }
        let viewController = viewControllers[selectTab.rawValue]
        if let diaryEditViewController = viewController as? DiaryEditViewController {
            diaryEditViewController.transitionType = .register
        }
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
        showAlert(title: "保存しました。",
                  actions: [UIAlertAction(title: "OK",
                                          style: .default)])
    }
}
