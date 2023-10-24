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
}
