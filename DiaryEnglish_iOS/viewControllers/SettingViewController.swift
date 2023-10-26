//
//  SettingViewController.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/07.
//

import UIKit
import SwiftyDI

protocol SettingViewControllerDelegate: AnyObject {
    func didVoiceSpeed(speedData: Float)
    func didVoicePich(pitchData: Float)
}

class SettingViewController: UIViewController {
    
    @IBOutlet weak var voiceSpeedSlider: UISlider!
    @IBOutlet weak var voicePichSlider: UISlider!
    @IBOutlet weak var voiceSpeedLabel: UILabel!
    @IBOutlet weak var voicePichLabel: UILabel!
    
    private static let defaultSpeedValue: Float = 0.5
    private static let defaultPitchValue: Float = 1.0
    
    @Injected
    private var userDefaultsUsecase: UserDefaultUsecase
    
    weak var delegate: SettingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    private func setupLayout() {
        voicePichSlider.minimumValue = 0.5
        voicePichSlider.maximumValue = 2.0
        
        let speed = if userDefaultsUsecase.isSpeedChange {
            userDefaultsUsecase.speed
        } else {
            Self.defaultSpeedValue
        }
        
        let pitch = if userDefaultsUsecase.isPitchChange {
            userDefaultsUsecase.pitch
        } else {
            Self.defaultPitchValue
        }
        
        voiceSpeedSlider.value = speed
        voicePichSlider.value = pitch
        voiceSpeedLabel.text = String(speed)
        voicePichLabel.text = String(pitch)
        delegate?.didVoiceSpeed(speedData: speed)
        delegate?.didVoicePich(pitchData: pitch)
    }
    
    @IBAction func voiceSpeedDidChange(_ sender: UISlider) {
        let speed = floor(sender.value * 10) / 10
        voiceSpeedLabel.text = String(speed)
        userDefaultsUsecase.speed = speed
        userDefaultsUsecase.isSpeedChange = true
        delegate?.didVoiceSpeed(speedData: speed)
    }
    
    @IBAction func voicePichDidChange(_ sender: UISlider) {
        let pitch = floor(sender.value * 10) / 10
        voicePichLabel.text = String(pitch)
        userDefaultsUsecase.pitch = pitch
        userDefaultsUsecase.isPitchChange = true
        delegate?.didVoicePich(pitchData: pitch)
    }
}
