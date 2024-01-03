//
//  AppDelegate.swift
//  DiaryEnglish_iOS
//
//  Created by 奥江英隆 on 2023/10/07.
//

import UIKit
import SwiftyDI
import UserNotifications
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @Injected
    private var userDefaultUsecase: UserDefaultUsecase
    
    static let isMockDataEnabled = false
    static let notificationReqeustIdentifire = "DiaryEnglishIdentifier"
    static let advertisementUnitId = "ca-app-pub-6663259427797114/5798838152"
    static let advertisementInterstitialUnitId = "ca-app-pub-6663259427797114/2726570800"

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
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        configureDependency()
        // アプリ初回起動時のみ
        if !userDefaultUsecase.isFirstTimeAppLaunch {
            userDefaultUsecase.isFirstTimeAppLaunch = true
            userDefaultUsecase.interstitialUpdate = Date()
        }
        sleep(1)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                UNUserNotificationCenter.current().delegate = self
                let content = UNMutableNotificationContent()
                content.title = "英語日記を書こう！"
                content.body = "言えなかった英語を記録しましょう！"
                content.sound = .default
                let dataComponents = DateComponents(calendar: Calendar.appCalender,
                                                    timeZone: TimeZone.japan,
                                                    hour: 19)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dataComponents, repeats: true)
                let request = UNNotificationRequest(identifier: Self.notificationReqeustIdentifire,
                                                    content: content,
                                                    trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .list, .badge, .banner])
    }
}

