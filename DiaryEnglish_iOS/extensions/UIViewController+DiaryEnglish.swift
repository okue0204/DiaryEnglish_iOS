//
//  UIViewController+DiaryEnglish.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/15.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String? = nil, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        actions.forEach {
            alert.addAction($0)
        }
        present(alert, animated: true)
    }
}
