//
//  DiaryEditViewController.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/07.
//

import UIKit

class DiaryEditViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    private func setupLayout() {
        headerView.delegate = self
        BackgroundAnimationManager.setupAnimation(view: view)
    }
}

extension DiaryEditViewController: HeaderViewDelegate {
    func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}
