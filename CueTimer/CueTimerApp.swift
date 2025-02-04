//
//  CueTimerApp.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-22.
//

import SwiftUI

@main
struct CueTimerApp: App {
    @StateObject var entries = Entries()
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color(red: 2/255, green: 128/255, blue: 146/255))
    }
    
    var body: some Scene {
        WindowGroup {
            Homepage(animationCompleted: false).environmentObject(entries)
        }
    }
}



