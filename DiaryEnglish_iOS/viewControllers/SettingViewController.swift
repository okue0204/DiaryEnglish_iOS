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
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var voiceSpeedSlider: UISlider!
    @IBOutlet weak var voicePichSlider: UISlider!
    @IBOutlet weak var voiceSpeedLabel: UILabel!
    @IBOutlet weak var voicePichLabel: UILabel!
    
    @Injected
    private var userDefaultsUsecase: UserDefaultUsecase
    
    weak var delegate: SettingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    private func setupLayout() {
        headerView.delegate = self
        voicePichSlider.minimumValue = 0.5
        voicePichSlider.maximumValue = 2.0
        voiceSpeedLabel.text = String(userDefaultsUsecase.speed)
        voicePichLabel.text = String(userDefaultsUsecase.pitch)
        voiceSpeedSlider.value = userDefaultsUsecase.speed
        voicePichSlider.value = userDefaultsUsecase.pitch
        delegate?.didVoiceSpeed(speedData: userDefaultsUsecase.speed)
        delegate?.didVoicePich(pitchData: userDefaultsUsecase.pitch)
        BackgroundAnimationManager.setupAnimation(view: view)
    }
    
    @IBAction func voiceSpeedDidChange(_ sender: UISlider) {
        let speed = floor(sender.value * 10) / 10
        voiceSpeedLabel.text = String(speed)
        userDefaultsUsecase.speed = speed
        delegate?.didVoiceSpeed(speedData: speed)
    }
    
    @IBAction func voicePichDidChange(_ sender: UISlider) {
        let pitch = floor(sender.value * 10) / 10
        voicePichLabel.text = String(pitch)
        userDefaultsUsecase.pitch = pitch
        delegate?.didVoicePich(pitchData: pitch)
    }
}

extension SettingViewController: HeaderViewDelegate {
    func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func defaultButtonDidTap() {
        showAlert(title: "初期設定に戻しますか？",
                  actions: [UIAlertAction(title: "はい",
                                          style: .default) { [weak self] _ in
            guard let self else { return }
            voiceSpeedSlider.value = 0.5
            voicePichSlider.value = 1.0
            voiceSpeedLabel.text = String(0.5)
            voicePichLabel.text = String(1.0)
            userDefaultsUsecase.speed = 0.5
            userDefaultsUsecase.pitch = 1.0
        }, UIAlertAction(title: "いいえ",
                         style: .cancel)])
    }
}
