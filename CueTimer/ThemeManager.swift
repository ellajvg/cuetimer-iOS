//
//  ThemeManager.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-12.
//

import SwiftUI
import FirebaseFirestore

class ThemeManager: ObservableObject {
    @Published var theme: Theme = Theme(darkR: 2, darkG: 128, darkB: 146,
                                        lightR: 211, lightG: 230, lightB: 233, shadowR: 125, shadowG: 160, shadowB: 170,
                                        themeName: "Teal")
    
    private var db = Firestore.firestore()
    
    func fetchTheme(userId: String, completion: @escaping (Bool) -> Void) {
        let userDoc = db.collection("users").document(userId)
        
        userDoc.getDocument { document, error in
            if let document = document, document.exists, let data = document.data(),
               let themeData = data["theme"] as? [String: Any],
               let darkR = themeData["darkR"] as? Int,
               let darkG = themeData["darkG"] as? Int,
               let darkB = themeData["darkB"] as? Int,
               let lightR = themeData["lightR"] as? Int,
               let lightG = themeData["lightG"] as? Int,
               let lightB = themeData["lightB"] as? Int,
               let shadowR = themeData["lightR"] as? Int,
               let shadowG = themeData["lightG"] as? Int,
               let shadowB = themeData["lightB"] as? Int,
               let themeName = themeData["themeName"] as? String {
                self.theme = Theme(darkR: darkR, darkG: darkG, darkB: darkB, lightR: lightR, lightG: lightG, lightB: lightB, shadowR: shadowR, shadowG: shadowG, shadowB: shadowB,themeName: themeName)
                completion(true)
            } else {
                self.saveTheme(userId: userId, theme: self.theme)
                completion(true)
            }
        }
    }
    
    func saveTheme(userId: String, theme: Theme) {
        let themeData: [String: Any] = [
            "darkR": theme.darkR,
            "darkG": theme.darkG,
            "darkB": theme.darkB,
            "lightR": theme.lightR,
            "lightG": theme.lightG,
            "shadowR": theme.shadowR,
            "shadowG": theme.shadowG,
            "shadowB": theme.shadowB,
            "themeName": theme.themeName
        ]
        db.collection("users").document(userId).setData(["theme": themeData], merge: true)
        self.theme = theme
    }
}

struct Theme {
    var darkR: Int
    var darkG: Int
    var darkB: Int
    var lightR: Int
    var lightG: Int
    var lightB: Int
    var shadowR: Int
    var shadowG: Int
    var shadowB: Int
    var themeName: String
    
    var darkColor: Color {
        Color(red: Double(darkR) / 255.0,
              green: Double(darkG) / 255.0,
              blue: Double(darkB) / 255.0)
    }
    
    var lightColor: Color {
        Color(red: Double(lightR) / 255.0,
              green: Double(lightG) / 255.0,
              blue: Double(lightB) / 255.0)
    }
    
    var shadowColor: Color {
        Color(red: Double(shadowR) / 255.0,
              green: Double(shadowG) / 255.0,
              blue: Double(shadowB) / 255.0)
    }
}
