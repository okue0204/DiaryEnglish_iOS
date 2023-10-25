//
//  UIStoryboard+DiaryEnglish.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/10.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    static let diaryListViewController = UIStoryboard(name: String(describing: DiaryListViewController.self), bundle: nil)
    
    static let diaryEditViewControllerStoryboard = UIStoryboard(name: String(describing: DiaryEditViewController.self), bundle: nil)
    
    static let settingViewControllerStoryboard = UIStoryboard(name: String(describing: SettingViewController.self), bundle: nil)
}
