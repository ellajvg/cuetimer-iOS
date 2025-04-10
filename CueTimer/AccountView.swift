//
//  AccountView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-24.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    authManager.showAccountPopover = false
                } label: {
                    Image(systemName: "x.circle.fill")
                        .font(.title)
                        .foregroundStyle(themeManager.theme.darkColor)
                        .padding(.top)
                        .padding(.horizontal)
                }
            }
            
            TabView {
                SavedView()
                    .tabItem {
                        Label("Saved", systemImage: "bookmark")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .tint(themeManager.theme.darkColor)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}
