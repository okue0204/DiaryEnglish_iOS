//
//  Optional+DiaryEnglish.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/15.
//

import Foundation

extension String? {
    var isNullOrEmpty: Bool {
        if let self, !self.isEmpty {
            return false
        } else {
            return true
        }
    }
}
