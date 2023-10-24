//
//  AppDelegate.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/07.
//

import UIKit
import SwiftyDI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let isMockDataEnabled = false

    private func cofigureDependencyForMock() {
        DIContainer {
            // usecase
            Dependency { UserDefaultUsecaseImpl() }
            
            // repository
            Dependency { UserDefaultRepositoryImpl() }
        }.build()
    }
    
    private func configureDependency() {
        DIContainer {
            // usecase
            Dependency { UserDefaultUsecaseImpl() }
            
            // repository
            Dependency { UserDefaultRepositoryImpl() }
        }.build()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if Self.isMockDataEnabled {
            cofigureDependencyForMock()
        } else {
            configureDependency()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

