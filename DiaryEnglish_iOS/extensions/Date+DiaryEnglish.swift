//
//  Date+DiaryEnglish.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2024/01/03.
//

import Foundation

extension Date {
    static func daysAfter(beforInterstitialDisplay: Date) -> Date {
        return Date(timeInterval: 60 * 60 * 24 * 7, since: beforInterstitialDisplay)
    }
}
