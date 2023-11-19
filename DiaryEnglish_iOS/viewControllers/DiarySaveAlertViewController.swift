//
//  DiarySaveAlertViewController.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/11/19.
//

import UIKit

protocol DiarySaveAlertViewControllerDelegate: AnyObject {
    func didAletClose()
}

class DiarySaveAlertViewController: UIViewController {
    
    enum Transition {
        case alert
        case save
        
        var title: String {
            return switch self {
            case .alert:
                "日本語日記と英語日記を入力して下さい。"
            case .save:
                "保存しますか？"
            }
        }
    }
    
    @IBOutlet weak var alertContainerView: UIView! {
        didSet {
            alertContainerView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = transition.title
        }
    }
    @IBOutlet weak var boarderView: UIView! {
        didSet {
            if case .alert = transition {
                boarderView.isHidden = true
            }
        }
    }
    @IBOutlet weak var cancellButton: UIButton! {
        didSet {
            if case .alert = transition {
                cancellButton.isHidden = true
            }
        }
    }
    
    weak var delegate: DiarySaveAlertViewControllerDelegate?
    
    var transition: Transition = .alert
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func okButtonDidTap(_ sender: Any) {
        if case .save = transition {
            dismiss(animated: true) { [weak self] in
                self?.delegate?.didAletClose()
            }
        } else {
            dismiss(animated: true)
        }
    }
    
    @IBAction func cancellButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
}
