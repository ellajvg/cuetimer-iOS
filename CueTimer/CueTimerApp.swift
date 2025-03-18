//
//  CueTimerApp.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-22.
//

import SwiftUI
import Firebase
import FirebaseAuth

class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
    return true
  }
}

@main
struct CueTimerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authManager = AuthManager()
    @StateObject var themeManager = ThemeManager()
    @StateObject var entries = Entries()
    
    var body: some Scene {
        WindowGroup {
            ResponsiveLayout { layoutProperties in
                LoginView(layoutProperties: layoutProperties)
                    .environmentObject(authManager)
                    .environmentObject(themeManager)
                    .environmentObject(entries)
                    .onAppear {
                        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(themeManager.theme.darkColor)
                    }
            }
        }
    }
}



