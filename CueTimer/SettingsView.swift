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

    let layoutProperties: LayoutProperties
    
    init(layoutProperties: LayoutProperties) {
        self.layoutProperties = layoutProperties
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Settings")
                        .font(.system(size: layoutProperties.customFontSize.large))
                        .fontWeight(.semibold)
                        .padding(.top, 30)
                    
                    VStack {
                        Text("App customization")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Image(systemName: "paintpalette")
                                .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                                .foregroundStyle(themeManager.theme.darkColor)
                            Text("Color")
                                .padding(.trailing, 30)
                            
                            HStack(spacing: 20) {
                                Button {
                                    if let userId = authManager.getCurrentUserId() {
                                        themeManager.saveTheme(userId: userId, theme: Theme(darkR: 2, darkG: 128, darkB: 146, lightR: 211, lightG: 230, lightB: 233, themeName: "Teal"))
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                                            .foregroundStyle(Color(red: 2/255, green: 128/255, blue: 146/255))
                                        if themeManager.theme.themeName == "Teal" {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(.white)
                                                .font(.system(size: layoutProperties.customFontSize.small * 0.7))
                                                .fontWeight(.semibold)
                                        }
                                    }
                                }
                                
                                Button {
                                    if let userId = authManager.getCurrentUserId() {
                                        themeManager.saveTheme(userId: userId, theme: Theme(darkR: 2, darkG: 58, darkB: 146, lightR: 218, lightG: 230, lightB: 245, themeName: "Blue"))
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                                            .foregroundStyle(Color(red: 2/255, green: 58/255, blue: 146/255))
                                        
                                        if themeManager.theme.themeName == "Blue" {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(.white)
                                                .font(.system(size: layoutProperties.customFontSize.small * 0.7))
                                                .fontWeight(.semibold)
                                        }
                                    }
                                }
                                
                                Button {
                                    if let userId = authManager.getCurrentUserId() {
                                        themeManager.saveTheme(userId: userId, theme: Theme(darkR: 96, darkG: 48, darkB: 126, lightR: 250, lightG: 231, lightB: 252, themeName: "Purple"))
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                                            .foregroundStyle(Color(red: 96/255, green: 48/255, blue: 126/255))
                                        
                                        if themeManager.theme.themeName == "Purple" {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(.white)
                                                .font(.system(size: layoutProperties.customFontSize.small * 0.7))
                                                .fontWeight(.semibold)
                                        }
                                    }
                                }
                                
                                Button {
                                    if let userId = authManager.getCurrentUserId() {
                                        themeManager.saveTheme(userId: userId, theme: Theme(darkR: 146, darkG: 2, darkB: 2, lightR: 249, lightG: 223, lightB: 223, themeName: "Red"))
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                                            .foregroundStyle(Color(red: 146/255, green: 2/255, blue: 2/255))
                                        
                                        if themeManager.theme.themeName == "Red" {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(.white)
                                                .font(.system(size: layoutProperties.customFontSize.small * 0.7))
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    
                                }
                                
                                Button {
                                    if let userId = authManager.getCurrentUserId() {
                                        themeManager.saveTheme(userId: userId, theme: Theme(darkR: 80, darkG: 80, darkB: 80, lightR: 232, lightG: 232, lightB: 232, themeName: "Gray"))
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                                            .foregroundStyle(Color(red: 80/255, green: 80/255, blue: 80/255))
                                        
                                        if themeManager.theme.themeName == "Gray" {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(.white)
                                                .font(.system(size: layoutProperties.customFontSize.small * 0.7))
                                                .fontWeight(.semibold)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        Divider()
                            .frame(height: 0.3)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                        HStack {
                            Image(systemName: "speaker.wave.2")
                                .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                                .foregroundStyle(themeManager.theme.darkColor)
                            Text("Volume")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30)
                    
                    VStack {
                        Text("Account management")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                        HStack {
                            Image(systemName: "at")
                                .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                                .foregroundStyle(themeManager.theme.darkColor)
                            Text("Change email")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        Divider()
                            .frame(height: 0.3)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                        HStack {
                            Image(systemName: "key")
                                .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                                .foregroundStyle(themeManager.theme.darkColor)
                            Text("Change password")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        Divider()
                            .frame(height: 0.3)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                                .foregroundStyle(themeManager.theme.darkColor)
                            Text("Logout")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        Divider()
                            .frame(height: 0.3)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                        HStack {
                            Image(systemName: "trash")
                                .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                                .foregroundStyle(themeManager.theme.darkColor)
                            Text("Delete account")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 30)
                    
                    VStack {
                        Text("Contact")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                            .padding(.horizontal, 20)
                        
                        Text("Found a bug? Want to request a feature? Send us an email!")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 5)
                            .padding(.bottom, 10)
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Image(systemName: "envelope")
                                .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                                .foregroundStyle(themeManager.theme.darkColor)
                            Text("cuetimer@gmail.com")
                                .tint(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    }
                    Spacer()
                }
                .font(.system(size: layoutProperties.customFontSize.small))
                .padding()
                .overlay(authManager.showLogoutAlert ? .gray.opacity(0.3) : .gray.opacity(0.0))
                .blur(radius: authManager.showLogoutAlert ? 0.6 : 0.0)
                

                if authManager.showLogoutAlert {
                    VStack(spacing: 0) {
                        Text("Confirm logout")
                            .font(.system(size: layoutProperties.customFontSize.small * 1.1))
                            .fontWeight(.semibold)
                            .padding(.top, 20)
                            .padding(.horizontal, 10)
                        
                        Text("Are you sure you want to logout?")
                            .font(.system(size: layoutProperties.customFontSize.small * 0.9))
                            .padding(.top, 5)
                            .padding(.bottom, 15)
                            .padding(.horizontal, 15)
                            .multilineTextAlignment(.center)
                        
                        
                        if authManager.showLogoutAlert && !authManager.logoutErrorText.isEmpty {
                            Text(authManager.logoutErrorText)
                                .font(.system(size: layoutProperties.customFontSize.small * 0.9))
                                .foregroundStyle(Color.darkAccent)
                                .padding(.top, -10)
                                .padding(.bottom, 15)
                                .padding(.horizontal, 15)
                                .multilineTextAlignment(.center)
                        }
                        
                        Divider()
                            .frame(maxWidth: .infinity)
                            .frame(height: 0.3)
                            .background(Color.gray.opacity(0.1))
                        
                        HStack(spacing: 0) {
                            Button("No") {
                                authManager.showLogoutAlert = false
                            }
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .foregroundStyle(Color.darkAccent)
                            Divider()
                                .frame(height: 40)
                                .background(Color.gray.opacity(0.01))
                            Button("Yes") {
                                authManager.signOut()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .foregroundStyle(Color.darkAccent)
                            .font(.system(size: layoutProperties.customFontSize.small * 1.1))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, y: 5)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 60)
                }
            }
            .navigationDestination(isPresented: $authManager.isUserLoggedOut) {
                LoginView(layoutProperties: layoutProperties)
            }
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveLayout { layoutProperties in
            SettingsView(layoutProperties: layoutProperties)
                .environmentObject(AuthManager())
                .environmentObject(ThemeManager())
                .environmentObject(Entries())
        }
        
    }
}
