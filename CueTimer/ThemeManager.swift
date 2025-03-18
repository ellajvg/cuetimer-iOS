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
                                        lightR: 211, lightG: 230, lightB: 233,
                                        themeName: "Teal")
    
    private var db = Firestore.firestore()
    
    func fetchTheme(userId: String) {
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
               let themeName = themeData["themeName"] as? String {
                self.theme = Theme(darkR: darkR, darkG: darkG, darkB: darkB, lightR: lightR, lightG: lightG, lightB: lightB, themeName: themeName)
            } else {
                self.saveTheme(userId: userId, theme: self.theme)
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
            "lightB": theme.lightB,
            "themeName": theme.themeName
        ]
        db.collection("users").document(userId).setData(["theme": themeData])
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
}
