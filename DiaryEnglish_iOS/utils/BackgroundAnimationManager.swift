//
//  BackgroundAnimationManager.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/10.
//

import Foundation
import Lottie
import UIKit

class BackgroundAnimationManager {

    static func setupAnimation(view: UIView) {
        var animationView = LottieAnimationView()
        animationView = LottieAnimationView(name: "winter_animation")
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.alpha = 0.3
        animationView.play()
        animationView.isUserInteractionEnabled = false
        view.addSubview(animationView)
    }
}
