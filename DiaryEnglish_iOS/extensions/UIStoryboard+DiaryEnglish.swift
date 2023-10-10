//
//  UIStoryboard+DiaryEnglish.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/10.
//

import Foundation
import UIKit

extension UIStoryboard {
    static let diaryEditViewController = UIStoryboard(name: String(describing: DiaryEditViewController.self), bundle: nil).instantiateInitialViewController() as! DiaryEditViewController
}
