//
//  AppDelegate.swift
//  testTextSelection
//
//  Created by James Tang on 29/3/2023.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

//        installMontereyTextSelectionCrashFix()
        UserDefaults.standard.register(defaults: [
            "NSApplicationCrashOnExceptions": true
        ])
        setupFirebase()
        installMacCatalystReportCrashAsException()
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

    private func setupFirebase() {
        FirebaseApp.configure()
        let crashlytics = Crashlytics.crashlytics()
        #if DEBUG
        crashlytics.setCrashlyticsCollectionEnabled(false)
        #endif
        crashlytics.setCustomValue(Locale.current.regionCode, forKey: "CountryCode")
    }

}
