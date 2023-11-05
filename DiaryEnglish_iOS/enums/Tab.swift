//
//  Tab.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/25.
//

import Foundation
import UIKit

enum Tab: Int {
    case home = 0
    case addDiary = 1
    case setting = 2
    
    var title: String {
        switch self {
        case .home:
            "英語日記一覧"
        case .addDiary:
            "英語日記追加"
        case .setting:
            "設定"
        }
    }
    
    var image: UIImage {
        switch self {
        case .home:
            UIImage.home
        case .addDiary:
            UIImage.addDiary
        case .setting:
            UIImage.setting
        }
    }
    
    var imageFil: UIImage {
        switch self {
        case .home:
            UIImage.homeFil
        case .addDiary:
            UIImage.addDiaryFil
        case .setting:
            UIImage.settingFill
        }
    }
}
