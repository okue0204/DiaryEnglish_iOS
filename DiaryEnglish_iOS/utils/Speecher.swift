//
//  Speecher.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/27.
//

import Foundation
import AVFAudio

class Speecher {
    
    static let shard = Speecher()
    private init() {}
    
    let defaultSpeedValue: Float = 0.5
    let defaultPitchValue: Float = 1.0
    
    private var speechSynthesizer = AVSpeechSynthesizer()
    
    func speech(voiceText: String, speed: Float? = nil, pitch: Float? = nil) {
        let utterance = AVSpeechUtterance.init(string: voiceText)
        if let speed {
            utterance.rate = speed
        }
        if let pitch {
            utterance.pitchMultiplier = pitch
        }
        utterance.voice = AVSpeechSynthesisVoice.init(language: "en-US")
        speechSynthesizer.speak(utterance)
    }
    
}
