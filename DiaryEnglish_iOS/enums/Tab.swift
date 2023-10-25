//
//  Tab.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/25.
//

import Foundation

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
}
