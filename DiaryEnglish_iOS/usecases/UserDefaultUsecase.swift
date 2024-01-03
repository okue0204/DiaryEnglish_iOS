//
//  UserDefaultRepository.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/23.
//

import Foundation
import SwiftyDI

protocol UserDefaultUsecase {
    var speed: Float { get set }
    var pitch: Float { get set }
    var isSpeedChange: Bool { get set }
    var isPitchChange: Bool { get set }
    var isFirstTimeAppLaunch: Bool { get set }
    var interstitialUpdate: Date? { get set }
}

class UserDefaultUsecaseImpl: UserDefaultUsecase {
    @Injected
    private var repository: UserDefaultRepository
    
    var speed: Float {
        get {
            repository.speed
        }
        set {
            repository.speed = newValue
        }
    }
    
    var pitch: Float {
        get {
            repository.pitch
        }
        set {
            repository.pitch = newValue
        }
    }
    
    var isSpeedChange: Bool {
        get {
            repository.isSpeedChange
        }
        set {
            repository.isSpeedChange = newValue
        }
    }
    
    var isPitchChange: Bool {
        get {
            repository.isPitchChange
        }
        set {
            repository.isPitchChange = newValue
        }
    }
    
    var isFirstTimeAppLaunch: Bool {
        get {
            repository.isFirstTimeAppLaunch
        }
        set {
            repository.isFirstTimeAppLaunch = newValue
        }
    }
    
    var interstitialUpdate: Date? {
        get {
            repository.interstitialUpdate
        }
        set {
            repository.interstitialUpdate = newValue
        }
    }
}
