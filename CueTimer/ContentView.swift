//
//  ContentView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-27.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var soundManager: SoundManager
    @State var goToHomepage: Bool = false
    
    var body: some View {
        if authManager.hasCurrentUser(), let userId = authManager.getUserId() {
            homepage
                .onAppear {
                    dataManager.getOrderPreference(userId: userId) { order in
                        dataManager.fetchWorkouts(userId: userId, order: order)
                    }
                    
                    soundManager.getSoundPreference(userId: userId) 
                    
                    themeManager.fetchTheme(userId: userId) { success in
                        if success {
                            goToHomepage = true
                        }
                    }
                }
        } else {
            login
        }
    }
    
    var homepage: some View {
        VStack {
            if goToHomepage {
                HomepageView(showAnimation: true)
                    .popover(isPresented: $authManager.showAccountPopover) {
                        AccountView()
                    }   
            }
        }
        
    }
    
    var login: some View {
        VStack {
            LoginView(showAnimation: true)
                .popover(isPresented: $authManager.showResetPopover) {
                    ResetPasswordView()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
            .environmentObject(SoundManager())
    }
}
