//
//  ResetPasswordView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-04-01.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var workoutName: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    authManager.showResetPopover = false
                } label: {
                    Image(systemName: "x.circle.fill")
                        .font(.title)
                        .foregroundStyle(themeManager.theme.darkColor)
                        .padding(.top)
                        .padding(.horizontal)
                }
            }
            
            
            VStack(spacing: 20) {
                VStack {
                    Text("Password reset")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    Text("Please enter the email address associated with you account and click send to reset your password.")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 10)
                        
                    Text("Email")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, -5)
                    
                    TextField("", text: $authManager.resetEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, authManager.showResetError ? 10 : 0)
                        .textInputAutocapitalization(.never)
                        .onChange(of: authManager.resetEmail) { oldValue, newValue in
                            authManager.resetEmail = newValue.filter { !$0.isWhitespace }
                        }
                    
                    if authManager.showResetError {
                        Text(authManager.resetErrorText)
                            .font(.callout)
                            .foregroundStyle(themeManager.theme.darkColor)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)
                    }
                }
                .boxStyle(foregroundStyle: .black, background: .white, shadowColor: .gray)
                
                HStack(spacing: 20) {
                    Button {
                        
                    } label: {
                        Text("Cancel")
                            .boxStyle(foregroundStyle: .black, background: .white, shadowColor: .gray)
                    }
                    .growingButton()
                    Button {
                        if authManager.resetEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            authManager.resetErrorText = "This is a required field."
                            authManager.showResetError = true
                        } else {
                            authManager.sendResetEmail(firstSend: true) { success in
                                if success {
                                    authManager.clearFields()
                                    authManager.showResetAlert = true
                                    authManager.showResetPopover = false
                                }
                            }
                        }
                    } label: {
                        Text("Send")
                            .boxStyle(foregroundStyle: .white, background: themeManager.theme.darkColor, shadowColor: .gray)
                    }
                    .growingButton()
                }
            }
            .padding(.top, 5)
            .padding(.horizontal)
            .padding(.bottom)
            
            Spacer()
        }
    }
}


struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}

