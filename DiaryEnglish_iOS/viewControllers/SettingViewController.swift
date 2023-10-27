//
//  SettingViewController.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/07.
//

import UIKit
import SwiftyDI

class SettingViewController: UIViewController {
    
    @IBOutlet weak var voiceSpeedSlider: UISlider!
    @IBOutlet weak var voicePichSlider: UISlider!
    @IBOutlet weak var voiceSpeedLabel: UILabel!
    @IBOutlet weak var voicePichLabel: UILabel!
    

    
    @Injected
    private var userDefaultsUsecase: UserDefaultUsecase
    
    let speecher = Speecher.shard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let containerViewController = self.parent as? DiaryContainerViewController {
            containerViewController.headerView.saveButton.isHidden = true
        }
    }
    
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
            speecher.defaultSpeedValue
        }
        
        let pitch = if userDefaultsUsecase.isPitchChange {
            userDefaultsUsecase.pitch
        } else {
            speecher.defaultPitchValue
        }
        
        voiceSpeedSlider.value = speed
        voicePichSlider.value = pitch
        voiceSpeedLabel.text = String(speed)
        voicePichLabel.text = String(pitch)
    }
    
    @IBAction func voiceSpeedDidChange(_ sender: UISlider) {
        let speed = floor(sender.value * 10) / 10
        voiceSpeedLabel.text = String(speed)
        userDefaultsUsecase.speed = speed
        userDefaultsUsecase.isSpeedChange = true
        userDefaultsUsecase.speed = speed
    }
    
    @IBAction func voicePichDidChange(_ sender: UISlider) {
        let pitch = floor(sender.value * 10) / 10
        voicePichLabel.text = String(pitch)
        userDefaultsUsecase.pitch = pitch
        userDefaultsUsecase.isPitchChange = true
        userDefaultsUsecase.pitch = pitch
        
    }
}
