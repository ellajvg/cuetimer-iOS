//
//  CueTimerApp.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CueTimerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var entries = Entries()
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color(red: 2/255, green: 128/255, blue: 146/255))
    }
    
    var body: some Scene {
        WindowGroup {
            ResponsiveView { layoutProperties in
                HomepageView(animationCompleted: false, layoutProperties: layoutProperties)
                    .environmentObject(entries)
            }
        }
    }
}



