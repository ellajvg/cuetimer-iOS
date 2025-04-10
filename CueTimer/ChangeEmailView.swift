//
//  ChangeEmailView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-20.
//

import SwiftUI

struct ChangeEmailView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var goToSettings: Bool = false
    @State private var showNextStep: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    var titleText: String {
                        if authManager.showConfirmation {
                            return "Success!"
                        } else if authManager.showVerifyAlert {
                            return "Check your inbox!"
                        } else {
                            return "Change email"
                        }
                    }
                    
                    Text(titleText)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                    
                    if !showNextStep {
                        Text("Please enter your current login credentials and click next.")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 10)
                        
                        AuthFieldsView()
                    } else if showNextStep && !authManager.showVerifyAlert {
                        Text("Please enter your new email and click confirm.")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 10)
                        
                        Text("New email")
                            .padding(.bottom, -5)
                        
                        TextField("", text: $authManager.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 15)
                            .textInputAutocapitalization(.never)
                            .onChange(of: authManager.email) { oldValue, newValue in
                                authManager.showDefaultError = false
                                authManager.email = newValue.filter { !$0.isWhitespace }
                                if authManager.showEmailError && oldValue != newValue {
                                    authManager.showEmailError = false
                                }
                                
                                if !newValue.isEmpty && !authManager.confirmEmail.isEmpty && newValue != authManager.confirmEmail {
                                    authManager.showMatchError = true
                                } else {
                                    authManager.showMatchError = false
                                }
                            }
                        
                        
                        if authManager.showEmailError {
                            Text(authManager.emailErrorText)
                                .font(.callout)
                                .foregroundStyle(themeManager.theme.darkColor)
                                .padding(.top, -15)
                                .padding(.bottom, 5)
                        }
                        
                        Text("Confirm new email")
                            .padding(.bottom, -5)
                        
                        TextField("", text: $authManager.confirmEmail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                            .textInputAutocapitalization(.never)
                            .onChange(of: authManager.confirmEmail) { oldValue, newValue in
                                authManager.showDefaultError = false
                                authManager.confirmEmail = newValue.filter { !$0.isWhitespace }
                                if authManager.showEmailError && oldValue != newValue {
                                    authManager.showEmailError = false
                                }
                                
                                if !newValue.isEmpty && newValue != authManager.email {
                                    authManager.showMatchError = true
                                } else {
                                    authManager.showMatchError = false
                                }
                            }
                        
                        if authManager.showMatchError {
                            Text("Emails do not match.")
                                .font(.callout)
                                .foregroundStyle(themeManager.theme.darkColor)
                                .padding(.top, -15)
                                .padding(.bottom, 5)
                        }
                        
                    } else if authManager.showVerifyAlert {
                        Text("We've sent you a verification email to your new address. Please click the link inside to verfy your email. Once verified, you'll be automatically redirected to the login screen.")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        
                        Text("IMPORTANT: The email for this account will not be updated until the new email has been verified. Please complete the verification process before leaving this screen.")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                    }
                    
                    if authManager.showDefaultError {
                        HStack {
                            Spacer()
                            Text(authManager.defaultErrorText)
                                .font(.callout)
                                .foregroundStyle(themeManager.theme.darkColor)
                                .padding(.bottom, 5)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    }
                }
                .boxStyle(foregroundStyle: .black, background: .white, shadowColor: .gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                
                HStack(spacing: 20) {
                    var buttonText: String {
                        if !showNextStep {
                            return "Next"
                        } else if authManager.showVerifyAlert {
                            return "Resend"
                        } else {
                            return "Confirm"
                        }
                    }
                    
                    Button {
                        goToSettings = true
                        authManager.showVerifyAlert = false
                        authManager.clearFields()
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
                                if authManager.email.isEmpty || authManager.password.isEmpty {
                                    authManager.defaultErrorText = "All fields are required."
                                    authManager.showDefaultError = true
                                } else {
                                    authManager.reauthenticate { success in
                                        if success {
                                            showNextStep = true
                                        }
                                    }
                                }
                            } else if authManager.showVerifyAlert {
                                authManager.sendVerificationEmail(firstSend: false)
                            } else if !authManager.showMatchError {
                                if authManager.email.isEmpty || authManager.confirmEmail.isEmpty {
                                    authManager.defaultErrorText = "All fields are required."
                                    authManager.showDefaultError = true
                                } else {
                                    authManager.updateEmail()
                                }
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

struct ChangeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEmailView()
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}
