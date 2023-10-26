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
    static let isSpeedChangeKey = "isSpeedChangeKey"
    static let isPitchChangeKey = "isPitchChangeKey"
    
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
    
    static var isSpeedChange: Bool {
        get {
            UserDefaults.standard.bool(forKey: Self.isSpeedChangeKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Self.isSpeedChangeKey)
        }
    }
    
    static var isPitckChange: Bool {
        get {
            UserDefaults.standard.bool(forKey: Self.isPitchChangeKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Self.isPitchChangeKey)
        }
    }
}
