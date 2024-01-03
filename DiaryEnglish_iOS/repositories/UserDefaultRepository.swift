//
//  UserDefaultRepository.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/23.
//

import Foundation

protocol UserDefaultRepository {
    var speed: Float { get set }
    var pitch: Float { get set }
    var isSpeedChange: Bool { get set }
    var isPitchChange: Bool { get set }
    var isFirstTimeAppLaunch: Bool { get set }
    var interstitialUpdate: Date? { get set }
}

class UserDefaultRepositoryImpl: UserDefaultRepository {
    var speed: Float {
        get {
            UserDefaults.speed
        }
        set {
            UserDefaults.speed = newValue
        }
    }
    
    var pitch: Float {
        get {
            UserDefaults.pitch
        }
        set {
            UserDefaults.pitch = newValue
        }
    }
    
    var isSpeedChange: Bool {
        get {
            UserDefaults.isSpeedChange
        }
        set {
            UserDefaults.isSpeedChange = newValue
        }
    }
    
    var isPitchChange: Bool {
        get {
            UserDefaults.isPitckChange
        }
        set {
            UserDefaults.isPitckChange = newValue
        }
    }
    
    var isFirstTimeAppLaunch: Bool {
        get {
            UserDefaults.isFirstTimeAppLaunch
        }
        set {
            UserDefaults.isFirstTimeAppLaunch = newValue
        }
    }
    
    var interstitialUpdate: Date? {
        get {
            UserDefaults.interstitialUpdate
        }
        set {
            UserDefaults.interstitialUpdate = newValue
        }
    }
}
