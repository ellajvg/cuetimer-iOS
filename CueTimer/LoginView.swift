//
//  LoginView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-02-28.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var themeManager: ThemeManager
    @FocusState private var showKeyboard: Bool
    @State private var signUp: Bool = false
    @State var showAnimation: Bool
    
    private var dark: Color { authManager.showVerifyAlert || authManager.showResetAlert ? Color(red: 80/256, green: 80/256, blue: 80/256) : Color.darkAccent
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LogoAnimation(showAnimation: $showAnimation)
                    .scaleEffect(showKeyboard || authManager.showResetPopover ? 0 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: showKeyboard)
                    .animation(.easeInOut(duration: 0.3), value: authManager.showResetPopover)
                
                if !showAnimation {
                    VStack(spacing: 20) {
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Welcome CueTi!")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 5)
                                .padding(.bottom, 10)
                            
                            Text("Email")
                                .padding(.bottom, -5)
                            
                            TextField("", text: $authManager.email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 10)
                                .textInputAutocapitalization(.never)
                                .focused($showKeyboard)
                                .onChange(of: authManager.email) { oldValue, newValue in
                                    authManager.showDefaultError = false
                                    authManager.email = newValue.filter { !$0.isWhitespace }
                                    if authManager.showEmailError && oldValue != newValue {
                                        authManager.showEmailError = false
                                    }
                                }
                            
                            if authManager.showEmailError {
                                Text(authManager.emailErrorText)
                                    .font(.callout)
                                    .foregroundStyle(Color.darkAccent)
                                    .padding(.top, -15)
                                    .padding(.bottom, 5)
                            }
                            
                            Text("Password")
                                .padding(.bottom, -5)
                            
                            SecureField("", text: $authManager.password)
                                .textContentType(.oneTimeCode)
                                .autocorrectionDisabled(true)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 10)
                                .textInputAutocapitalization(.never)
                                .focused($showKeyboard)
                                .onChange(of: authManager.password) { oldValue, newValue in
                                    authManager.password = newValue.filter { !$0.isWhitespace }
                                    if signUp {
                                        authManager.showDefaultError = false
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
                                }
                            
                            if authManager.showLengthError {
                                Text("Password must be at least 6 characters.")
                                    .font(.callout)
                                    .foregroundStyle(dark)
                                    .padding(.top, -15)
                                    .padding(.bottom, 5)
                            }
                            
                            if signUp {
                                Text("Confirm password")
                                    .padding(.bottom, -5)
                                SecureField("", text: $authManager.confirmPassword)
                                    .textContentType(.oneTimeCode)
                                    .autocorrectionDisabled(true)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.bottom, 10)
                                    .textInputAutocapitalization(.never)
                                    .focused($showKeyboard)
                                    .onChange(of: authManager.confirmPassword) { oldValue, newValue in
                                        authManager.confirmPassword = newValue.filter { !$0.isWhitespace }
                                        authManager.showDefaultError = false
                                        if !newValue.isEmpty && newValue != authManager.password {
                                            authManager.showMatchError = true
                                        } else {
                                            authManager.showMatchError = false
                                        }
                                    }
                                if authManager.showMatchError {
                                    Text("Passwords do not match.")
                                        .font(.callout)
                                        .foregroundStyle(dark)
                                        .padding(.top, -15)
                                        .padding(.bottom, 5)
                                }
                            }
                            
                            if authManager.showDefaultError {
                                HStack {
                                    Spacer()
                                    Text(authManager.defaultErrorText)
                                        .foregroundStyle(dark)
                                        .padding(.bottom, signUp ? 5 : 1)
                                        .multilineTextAlignment(signUp ? .center : .trailing)
                                    if signUp {
                                        Spacer()
                                    }
                                }
                            }
                            
                            if !signUp {
                                HStack {
                                    Spacer()
                                    Button("Forgot password?") {
                                        authManager.clearFields()
                                        authManager.showResetPopover = true
                                    }
                                    .fontWeight(authManager.showDefaultError ? .semibold : .regular)
                                    .foregroundStyle(dark)
                                    .padding(.bottom, 5)
                                }
                            }
                        }
                        .boxStyle(foregroundStyle: .black, background: .white, shadowColor: .gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        HStack(spacing: 20) {
                            Button {
                                if signUp {
                                    authManager.clearFields()
                                    showKeyboard = false
                                    signUp = false
                                } else {
                                    if authManager.email.isEmpty || authManager.password.isEmpty {
                                        authManager.defaultErrorText = "All fields are required."
                                        authManager.showDefaultError = true
                                    } else {
                                        showKeyboard = false
                                        authManager.login()
                                    }
                                }
                            } label: {
                                Text("Login")
                                    .boxStyle(foregroundStyle: signUp ? .black : .white, background: signUp ? .white : dark, shadowColor: .gray)
                            }
                            .growingButton()
                            Button {
                                if signUp && !(authManager.showLengthError || authManager.showMatchError || authManager.showEmailError) {
                                    if authManager.email.isEmpty || authManager.password.isEmpty || authManager.confirmPassword.isEmpty {
                                        authManager.defaultErrorText = "All fields are required."
                                        authManager.showDefaultError = true
                                    } else {
                                        showKeyboard = false
                                        authManager.register()
                                    }
                                } else {
                                    authManager.clearFields()
                                    showKeyboard = false
                                    signUp = true
                                }
                            } label: {
                                Text("Sign up")
                                    .boxStyle(foregroundStyle: signUp ? .white : .black, background: signUp ? dark : .white, shadowColor: .gray)
                            }
                            .growingButton()
                        }
                    }
                    .padding()
                    .transition(AnyTransition.move(edge: .bottom))
                    .overlay(authManager.showVerifyAlert || authManager.showResetAlert ? .gray.opacity(0.3) : .gray.opacity(0.0))
                    .blur(radius: authManager.showVerifyAlert || authManager.showResetAlert ? 0.6 : 0.0)
                }
                
                if authManager.showVerifyAlert || authManager.showResetAlert {
                    let alertTitle = "Check your inbox!"
                    let alertText = authManager.showVerifyAlert ? "We've sent you an email. Please click the link inside to verify your email. The screen will update automatically once verified." : "If an account exists with this email, you will receive a link to reset your password."
                    
                        VStack(spacing: 0) {
                            Text(alertTitle)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.top, 20)
                                .padding(.horizontal, 10)
                            
                            if authManager.showVerifyAlert && authManager.showVerifyTimeout {
                                VStack {
                                    Text("Uh oh! Verification timed out before you confirmed your email.")
                                        .padding(.bottom, 5)
                                    Button("Click here to refresh and try again.") {
                                        authManager.checkEmailVerification()
                                    }
                                    .foregroundStyle(Color.darkAccent)
                                    .fontWeight(.semibold)
                                }
                                .font(.body)
                                .padding(.top, 10)
                                .padding(.bottom, 17.5)
                                .padding(.horizontal, 15)
                                .multilineTextAlignment(.center)
                            } else {
                                Text(alertText)
                                    .padding(.top, 5)
                                    .padding(.bottom, 15)
                                    .padding(.horizontal, 15)
                                    .multilineTextAlignment(.center)
                            }
                            
                            if authManager.resent {
                                Text("Email has been resent!")
                                    .font(.callout)
                                    .foregroundStyle(Color.darkAccent)
                                    .padding(.top, -10)
                                    .padding(.bottom, 10)
                                    .padding(.horizontal, 15)
                                    .multilineTextAlignment(.center)
                            } else if authManager.showVerifyAlert && !authManager.verifyErrorText.isEmpty {
                                Text(authManager.verifyErrorText)
                                    .font(.callout)
                                    .foregroundStyle(Color.darkAccent)
                                    .padding(.top, -10)
                                    .padding(.bottom, 10)
                                    .padding(.horizontal, 15)
                                    .multilineTextAlignment(.center)
                            } else if authManager.showResetAlert && !authManager.resetErrorText.isEmpty {
                                Text(authManager.resetErrorText)
                                    .font(.callout)
                                    .foregroundStyle(Color.darkAccent)
                                    .padding(.top, -10)
                                    .padding(.bottom, 10)
                                    .padding(.horizontal, 15)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Divider()
                                .frame(maxWidth: .infinity)
                            
                            HStack(spacing: 0) {
                                Button("Close") {
                                    authManager.showVerifyAlert = false
                                    authManager.verifyErrorText = ""
                                    authManager.showResetAlert = false
                                    authManager.resetErrorText = ""
                                    authManager.resent = false
                                }
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                Divider()
                                    .frame(height: 42)
                                Button("Resend") {
                                    if authManager.showVerifyAlert {
                                        authManager.sendVerificationEmail(firstSend: false)
                                    } else {
                                        authManager.sendResetEmail(firstSend: false) { success in }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                                .padding(10)
                            }
                            .foregroundStyle(Color.darkAccent)
                            .font(.title3)
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 4, y: 4)
                        .padding(.horizontal, 50)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(showAnimation: true)
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}

