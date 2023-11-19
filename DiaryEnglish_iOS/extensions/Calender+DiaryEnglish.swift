//
//  Calender+DiaryEnglish.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/11/19.
//

import Foundation

extension Calendar {
    static var appCalender: Calendar = {
        var calender = Calendar(identifier: .gregorian)
        calender.locale = Locale.japan
        calender.timeZone = TimeZone.japan
        return calender
    }()
}
