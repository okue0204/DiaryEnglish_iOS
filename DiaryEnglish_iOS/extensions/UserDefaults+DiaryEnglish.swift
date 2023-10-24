//
//  UserDefaults+DiaryEnglish.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/23.
//

import Foundation


extension UserDefaults {
    
    static let speedKey = "speedKey"
    static let pitchKey = "pitchKey"
    
    static var speed: Float {
        get {
            UserDefaults.standard.float(forKey: Self.speedKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Self.speedKey)
        }
    }
    
    static var pitch: Float {
        get {
            UserDefaults.standard.float(forKey: Self.pitchKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Self.pitchKey)
        }
    }
}
