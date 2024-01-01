//
//  HowToSpeakingViewController.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/12/24.
//

import UIKit

class HowToSpeakingViewController: UIViewController {
    
    @IBOutlet weak var headerView: HeaderView! {
        didSet {
            headerView.delegate = self
            headerView.title = "チュートリアル"
            headerView.isShowSaveButton = false
            headerView.isShowCloseButton = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
}

extension HowToSpeakingViewController: HeaderViewDelegate {
    func didClose() {
        dismiss(animated: true)
    }
}
