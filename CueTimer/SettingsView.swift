//
//  SettingsView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-12.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var soundManager: SoundManager
    @State private var showColors: Bool = false
    @State private var showVolume: Bool = false
    @State private var showLogout: Bool = false
    
    @State private var editAccount: Bool = false
    @State private var type: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Settings")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    VStack {
                        Text("App customization")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                        
                        VStack(spacing: 15) {
                            if !showColors {
                                VStack {
                                    Button {
                                        withAnimation {
                                            showColors = true
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "paintpalette")
                                                .frame(width: 25,  alignment: .leading)
                                                .foregroundStyle(themeManager.theme.darkColor)
                                            Text("Color")
                                                .foregroundStyle(.black)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(themeManager.theme.darkColor)
                                                .frame(height: 20)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .transition(.move(edge: .leading).combined(with: .opacity).animation(.easeInOut(duration: 0.1)))
                                
                            } else {
                                HStack(spacing: 20) {
                                    Button {
                                        withAnimation {
                                            showColors = false
                                        }
                                    } label: {
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(themeManager.theme.darkColor)
                                            .offset(y: 2)
                                    }
                                    Spacer()
                                    
                                    Button {
                                        if let userId = authManager.getUserId() {
                                            themeManager.saveTheme(userId: userId, theme: Theme(darkR: 2, darkG: 128, darkB: 146, lightR: 211, lightG: 230, lightB: 233, shadowR: 115, shadowG: 150, shadowB: 160, themeName: "Teal"))
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .frame(width: 25,  alignment: .leading)
                                                .foregroundStyle(Color(red: 2/255, green: 128/255, blue: 146/255))
                                            if themeManager.theme.themeName == "Teal" {
                                                Image(systemName: "checkmark")
                                                    .foregroundStyle(.white)
                                                    .font(.footnote)
                                                    .fontWeight(.semibold)
                                            }
                                        }
                                    }
                                    
                                    Button {
                                        if let userId = authManager.getUserId() {
                                            themeManager.saveTheme(userId: userId, theme: Theme(darkR: 2, darkG: 58, darkB: 146, lightR: 218, lightG: 230, lightB: 245, shadowR: 105, shadowG: 130, shadowB: 160, themeName: "Blue"))
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .frame(width: 25,  alignment: .leading)
                                                .foregroundStyle(Color(red: 2/255, green: 58/255, blue: 146/255))
                                            
                                            if themeManager.theme.themeName == "Blue" {
                                                Image(systemName: "checkmark")
                                                    .foregroundStyle(.white)
                                                    .font(.footnote)
                                                    .fontWeight(.semibold)
                                            }
                                        }
                                    }
                                    
                                    Button {
                                        if let userId = authManager.getUserId() {
                                            themeManager.saveTheme(userId: userId, theme: Theme(darkR: 96, darkG: 48, darkB: 126, lightR: 250, lightG: 231, lightB: 252, shadowR: 140, shadowG: 115, shadowB: 155, themeName: "Purple"))
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .frame(width: 25,  alignment: .leading)
                                                .foregroundStyle(Color(red: 96/255, green: 48/255, blue: 126/255))
                                            
                                            if themeManager.theme.themeName == "Purple" {
                                                Image(systemName: "checkmark")
                                                    .foregroundStyle(.white)
                                                    .font(.footnote)
                                                    .fontWeight(.semibold)
                                            }
                                        }
                                    }
                                    
                                    Button {
                                        if let userId = authManager.getUserId() {
                                            themeManager.saveTheme(userId: userId, theme: Theme(darkR: 146, darkG: 2, darkB: 2, lightR: 249, lightG: 223, lightB: 223, shadowR: 170, shadowG: 110, shadowB: 110, themeName: "Red"))
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .frame(width: 25,  alignment: .leading)
                                                .foregroundStyle(Color(red: 146/255, green: 2/255, blue: 2/255))
                                            
                                            if themeManager.theme.themeName == "Red" {
                                                Image(systemName: "checkmark")
                                                    .foregroundStyle(.white)
                                                    .font(.footnote)
                                                    .fontWeight(.semibold)
                                            }
                                        }
                                        
                                    }
                                    
                                    Button {
                                        if let userId = authManager.getUserId() {
                                            themeManager.saveTheme(userId: userId, theme: Theme(darkR: 80, darkG: 80, darkB: 80, lightR: 232, lightG: 232, lightB: 232, shadowR: 145, shadowG: 145, shadowB: 145, themeName: "Gray"))
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .frame(width: 25,  alignment: .leading)
                                                .foregroundStyle(Color(red: 80/255, green: 80/255, blue: 80/255))
                                            
                                            if themeManager.theme.themeName == "Gray" {
                                                Image(systemName: "checkmark")
                                                    .foregroundStyle(.white)
                                                    .font(.footnote)
                                                    .fontWeight(.semibold)
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.move(edge: .trailing).combined(with: .opacity).animation(.easeInOut(duration: 0.1)))
                            }
                            
                            Divider()
                            
                            if !showVolume {
                                VStack {
                                    HStack {
                                        Button {
                                            withAnimation {
                                                showVolume = true
                                            }
                                        } label: {
                                            Image(systemName: "speaker.wave.2")
                                                .frame(width: 25,  alignment: .leading)
                                                .foregroundStyle(themeManager.theme.darkColor)
                                            Text("Sound")
                                                .foregroundStyle(.black)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(themeManager.theme.darkColor)
                                                .frame(height: 20)
                                        }
                                        
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .transition(.move(edge: .leading).combined(with: .opacity).animation(.easeInOut(duration: 0.1)))
                            } else {
                                HStack(spacing: 20) {
                                    Button {
                                        withAnimation {
                                            showVolume = false
                                        }
                                    } label: {
                                        Image(systemName: "chevron.right")
                                            .offset(y: 2)
                                    }
                                    Spacer()
                                    Button("On") {
                                        if let userId = authManager.getUserId() {
                                            soundManager.saveSoundPreference(userId: userId, sound: true)
                                        }
                                    }
                                    .fontWeight(soundManager.sound ? .bold : .regular)
                                    Button("Off") {
                                        if let userId = authManager.getUserId() {
                                            soundManager.saveSoundPreference(userId: userId, sound: false)
                                        }
                                    }
                                    .fontWeight(soundManager.sound ? .regular : .bold)
                                }
                                .foregroundStyle(themeManager.theme.darkColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.move(edge: .trailing).combined(with: .opacity).animation(.easeInOut(duration: 0.1)))
                            }
                            
                        }
                    }
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    
                    VStack {
                        Text("Account management")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                        
                        VStack(spacing: 15) {
                            Button {
                                type = 1
                                editAccount = true
                            } label: {
                                HStack {
                                    Image(systemName: "at")
                                        .frame(width: 25,  alignment: .leading)
                                        .foregroundStyle(themeManager.theme.darkColor)
                                    Text("Change email")
                                        .foregroundStyle(.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(themeManager.theme.darkColor)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            
                            Divider()
                            
                            Button {
                                type = 2
                                editAccount = true
                            } label: {
                                HStack {
                                    Image(systemName: "key")
                                        .frame(width: 25,  alignment: .leading)
                                        .foregroundStyle(themeManager.theme.darkColor)
                                    Text("Change password")
                                        .foregroundStyle(.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(themeManager.theme.darkColor)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Divider()
                            
                            if !showLogout {
                                VStack {
                                    Button {
                                        withAnimation {
                                            showLogout = true
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                                .frame(width: 25,  alignment: .leading)
                                                .foregroundStyle(themeManager.theme.darkColor)
                                            Text("Logout")
                                                .foregroundStyle(.black)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(themeManager.theme.darkColor)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .transition(.move(edge: .leading).combined(with: .opacity).animation(.easeInOut(duration: 0.1)))
                            } else {
                                HStack(spacing: 20) {
                                    Button {
                                        withAnimation {
                                            showLogout = false
                                        }
                                    } label: {
                                        Image(systemName: "chevron.right")
                                            .offset(y: 2)
                                    }
                                    Spacer()
                                    Button("Confirm logout") {
                                        authManager.signOut()
                                    }
                                }
                                .foregroundStyle(themeManager.theme.darkColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.move(edge: .trailing).combined(with: .opacity).animation(.easeInOut(duration: 0.1)))
                            }
                            
                            Divider()
                            
                            Button {
                                type = 3
                                editAccount = true
                            } label: {
                                HStack {
                                    Image(systemName: "trash")
                                        .frame(width: 25,  alignment: .leading)
                                        .foregroundStyle(themeManager.theme.darkColor)
                                    Text("Delete account")
                                        .foregroundStyle(.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(themeManager.theme.darkColor)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    VStack {
                        Text("Contact")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                            .padding(.horizontal, 20)
                        
                        Text("Found a bug? Have feedback? Send me an email!")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 5)
                            .padding(.bottom, 10)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Image(systemName: "envelope")
                                .frame(width: 25,  alignment: .leading)
                                .foregroundStyle(themeManager.theme.darkColor)
                            Text("cuetimer@gmail.com")
                                .tint(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationDestination(isPresented: $editAccount) {
                if type == 1 {
                    ChangeEmailView()
                } else if type == 2 {
                    ChangePasswordView()
                } else if type == 3 {
                    DeleteAccountView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
            .environmentObject(SoundManager())
    }
}
