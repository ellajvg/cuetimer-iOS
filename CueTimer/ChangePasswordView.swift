//
//  ChangePasswordView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-20.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var goToSettings: Bool = false
    @State private var showNextStep: Bool = false
    @State private var forgotPassword: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    var titleText: String {
                        if forgotPassword {
                            return "Reset password"
                        } else if authManager.showConfirmation {
                            return "Success!"
                        } else {
                            return "Change password"
                        }
                    }
                    
                    var instructionText: String {
                        if forgotPassword {
                            return "To reset your password, please log out."
                        } else if showNextStep {
                            return "Please enter your new password and click confirm."
                        } else if authManager.showConfirmation {
                            return "You've successfully changed the password to your account!"
                        } else {
                            return "Please enter your current login credentials and click next."
                        }
                    }
                    
                    Text(titleText)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                    
                    Text(instructionText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .padding(10)
                    
                    if !forgotPassword {
                        if !showNextStep {
                            AuthFieldsView()
                        } else if showNextStep && !authManager.showConfirmation {
                            Text("New password")
                                .padding(.bottom, -5)
                            
                            SecureField("", text: $authManager.password)
                                .textContentType(.oneTimeCode)
                                .autocorrectionDisabled(true)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 10)
                                .textInputAutocapitalization(.never)
                                .onChange(of: authManager.password) { oldValue, newValue in
                                    if !newValue.isEmpty && newValue.count < 6 {
                                        authManager.showLengthError = true
                                    } else {
                                        authManager.showLengthError = false
                                    }
                                    
                                    if !newValue.isEmpty && !authManager.confirmPassword.isEmpty && newValue != authManager.confirmPassword {
                                        authManager.showMatchError = true
                                    } else {
                                        authManager.showMatchError = false
                                    }
                                }
                            
                            if authManager.showLengthError {
                                Text("Password must be at least 6 characters.")
                                    .font(.callout)
                                    .foregroundStyle(themeManager.theme.darkColor)
                                    .padding(.top, -15)
                                    .padding(.bottom, 5)
                            }
                            
                            Text("Confirm new password")
                                .padding(.bottom, -5)
                            
                            SecureField("", text: $authManager.confirmPassword)
                                .textContentType(.oneTimeCode)
                                .autocorrectionDisabled(true)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 10)
                                .textInputAutocapitalization(.never)
                                .onChange(of: authManager.confirmPassword) { oldValue, newValue in
                                    if !newValue.isEmpty && newValue != authManager.password {
                                        authManager.showMatchError = true
                                    } else {
                                        authManager.showMatchError = false
                                    }
                                }
                            
                            if authManager.showMatchError {
                                Text("Passwords do not match.")
                                    .font(.callout)
                                    .foregroundStyle(themeManager.theme.darkColor)
                                    .padding(.top, -15)
                                    .padding(.bottom, 5)
                            }
                        }
                    }
                    
                    if authManager.showDefaultError {
                        HStack {
                            Spacer()
                            Text(authManager.defaultErrorText)
                                .font(.callout)
                                .foregroundStyle(themeManager.theme.darkColor)
                                .padding(.bottom, showNextStep ? 5 : 1)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    if !showNextStep &&  !forgotPassword {
                        HStack {
                            Spacer()
                            Button("Forgot password?") {
                                if forgotPassword {
                                    forgotPassword = false
                                } else {
                                    authManager.clearFields()
                                    forgotPassword = true
                                }
                            }
                            .font(.callout)
                            .fontWeight(authManager.showDefaultError ? .semibold : .regular)
                            .foregroundStyle(themeManager.theme.darkColor)
                            .padding(.bottom, 5)
                        }
                    }
                }
                .boxStyle(foregroundStyle: .black, background: .white, shadowColor: .gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                
                HStack(spacing: 20) {
                    var buttonText: String {
                        if !showNextStep && !forgotPassword {
                            return "Next"
                        } else if !showNextStep && forgotPassword {
                            return "Log out"
                        } else if authManager.showConfirmation {
                            return "Home"
                        } else {
                            return "Confirm"
                        }
                    }
                    
                    Button {
                        if forgotPassword {
                            forgotPassword = false
                        } else {
                            goToSettings = true
                            authManager.clearFields()
                        }
                    } label: {
                        ZStack {
                            HStack {
                                Image(systemName: "chevron.left")
                                Spacer()
                            }
                            Text(authManager.showConfirmation ? "Settings" : "Cancel")
                        }
                        .boxStyle(foregroundStyle: .black, background: .white, shadowColor: .gray)
                    }
                    .growingButton()
                    Button {
                        withTransaction(Transaction(animation: nil)) {
                            if !showNextStep {
                                if forgotPassword {
                                    authManager.signOut()
                                } else if authManager.email.isEmpty || authManager.password.isEmpty {
                                    authManager.defaultErrorText = "All fields are required."
                                    authManager.showDefaultError = true
                                } else {
                                    authManager.reauthenticate { success in
                                        if success {
                                            showNextStep = true
                                        }
                                    }
                                }
                            } else if !authManager.showConfirmation && !authManager.showMatchError && !authManager.showLengthError {
                                authManager.updatePassword()
                            } else if authManager.showConfirmation {
                                authManager.showAccountPopover = false
                            }
                        }
                    } label: {
                        Text(buttonText)
                            .boxStyle(foregroundStyle: .white, background: themeManager.theme.darkColor, shadowColor: .gray)
                    }
                    .growingButton()
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
            .navigationDestination(isPresented: $goToSettings) {
                SettingsView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}
