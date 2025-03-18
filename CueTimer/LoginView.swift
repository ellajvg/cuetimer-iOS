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
    @State var signUp: Bool = true
    @State private var progress: CGFloat = 0.0
    @State private var logoScale: CGFloat = 1.0
    @State private var logoOffsetY: CGFloat = 0.0
    @State private var showAnimation: Bool = true
    
    let layoutProperties: LayoutProperties
    
    private var dark: Color { authManager.showVerifyAlert || authManager.showResetAlert || authManager.showResetEntry ? Color(red: 80/256, green: 80/256, blue: 80/256) : Color.darkAccent
    }
    
    var body: some View {
        if authManager.hasCurrentUser() {
            HomepageView(layoutProperties: layoutProperties)
                .onAppear {
                    if let userId = authManager.getCurrentUserId() {
                        themeManager.fetchTheme(userId: userId)
                    }
                }
         } else {
            content
        }
    }
    
    var content: some View {
        NavigationStack {
            ZStack {
                Image(authManager.showVerifyAlert || authManager.showResetAlert || authManager.showResetEntry ? "LogoGray" : "LogoTeal")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: logoOffsetY)
                    .scaleEffect(showKeyboard ? 0 : logoScale)
                    .animation(.easeInOut(duration: 0.2), value: showKeyboard)
                    .onAppear {
                        if showAnimation {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    logoScale = 0.8
                                    logoOffsetY = -UIScreen.main.bounds.height / 3.6
                                    showAnimation = false
                                }
                            }
                        } else {
                            logoScale = 0.8
                            logoOffsetY = -UIScreen.main.bounds.height / 3.6
                        }
                    }
                
                if !showAnimation {
                    VStack(spacing: 20) {
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Welcome CueTi!")
                                .font(.system(size: layoutProperties.customFontSize.smallMedium * 1.2))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 5)
                                .padding(.bottom, 10)
                            
                            Text("Email")
                                .font(.system(size: layoutProperties.customFontSize.small))
                                .padding(.bottom, -5)
                            
                            TextField("", text: $authManager.email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 15)
                                .textInputAutocapitalization(.never)
                                .focused($showKeyboard)
                                .onChange(of: authManager.email) { oldValue, newValue in
                                    authManager.showDefaultError = false
                                    if authManager.showEmailError && oldValue != newValue {
                                        authManager.showEmailError = false
                                    }
                                }
                            
                            if authManager.showEmailError {
                                Text(authManager.emailErrorText)
                                    .font(.system(size: layoutProperties.customFontSize.small * 0.9))
                                    .foregroundStyle(Color.darkAccent)
                                    .padding(.top, -15)
                                    .padding(.bottom, 5)
                            }
                            
                            Text("Password")
                                .font(.system(size: layoutProperties.customFontSize.small))
                                .padding(.bottom, -5)
                            
                            SecureField("", text: $authManager.password)
                                .textContentType(.oneTimeCode)
                                .autocorrectionDisabled(true)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 10)
                                .textInputAutocapitalization(.never)
                                .focused($showKeyboard)
                                .onChange(of: authManager.password) { oldValue, newValue in
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
                                    .font(.system(size: layoutProperties.customFontSize.small * 0.9))
                                    .foregroundStyle(dark)
                                    .padding(.top, -15)
                                    .padding(.bottom, 5)
                            }
                            
                            if signUp {
                                Text("Confirm password")
                                    .font(.system(size: layoutProperties.customFontSize.small))
                                    .padding(.bottom, -5)
                                SecureField("", text: $authManager.confirmPassword)
                                    .textContentType(.oneTimeCode)
                                    .autocorrectionDisabled(true)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.bottom, 10)
                                    .textInputAutocapitalization(.never)
                                    .focused($showKeyboard)
                                    .onChange(of: authManager.confirmPassword) { oldValue, newValue in
                                        authManager.showDefaultError = false
                                        if !newValue.isEmpty && newValue != authManager.password {
                                            authManager.showMatchError = true
                                        } else {
                                            authManager.showMatchError = false
                                        }
                                    }
                                if authManager.showMatchError {
                                    Text("Passwords do not match.")
                                        .font(.system(size: layoutProperties.customFontSize.small * 0.9))
                                        .foregroundStyle(dark)
                                        .padding(.top, -15)
                                        .padding(.bottom, 5)
                                }
                            }
                            
                            if authManager.showDefaultError {
                                HStack {
                                    Spacer()
                                    Text(authManager.defaultErrorText)
                                        .font(.system(size: layoutProperties.customFontSize.small * 0.9))
                                        .foregroundStyle(dark)
                                        .padding(.bottom, signUp ? 5 : 0)
                                        .multilineTextAlignment(.center)
                                    if signUp {
                                        Spacer()
                                    }
                                }
                            }
                            
                            if !signUp {
                                HStack {
                                    Spacer()
                                    Button("Forgot password?") {
                                        authManager.showResetEntry = true
                                    }
                                    .font(.system(size: layoutProperties.customFontSize.small * 0.9))
                                    .fontWeight(authManager.showDefaultError ? .semibold : .regular)
                                    .foregroundStyle(dark)
                                    .padding(.bottom, 5)
                                }
                            }
                        }
                        .boxStyle(foregroundStyle: .black, background: .white, shadowColor: .gray)
                        .font(.system(size: layoutProperties.customFontSize.small))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        HStack(spacing: 20) {
                            Button("Login") {
                                if signUp {
                                    authManager.email = ""
                                    authManager.password = ""
                                    authManager.confirmPassword = ""
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
                            }
                            .boxStyle(foregroundStyle: signUp ? .black : .white, background: signUp ? .white : dark, shadowColor: .gray)
                            
                            Button("Sign up") {
                                if signUp && !(authManager.showLengthError || authManager.showMatchError || authManager.showEmailError) {
                                    if authManager.email.isEmpty || authManager.password.isEmpty || authManager.confirmPassword.isEmpty {
                                        authManager.defaultErrorText = "All fields are required."
                                        authManager.showDefaultError = true
                                    } else {
                                        showKeyboard = false
                                        authManager.register()
                                    }
                                } else {
                                    authManager.email = ""
                                    authManager.password = ""
                                    authManager.confirmPassword = ""
                                    showKeyboard = false
                                    signUp = true
                                }
                            }
                            .boxStyle(foregroundStyle: signUp ? .white : .black, background: signUp ? dark : .white, shadowColor: .gray)
                        }
                        .font(.system(size: layoutProperties.customFontSize.small))
                    }
                    .padding()
                    .transition(AnyTransition.move(edge: .bottom))
                    .overlay(authManager.showVerifyAlert || authManager.showResetAlert || authManager.showResetEntry ? .gray.opacity(0.3) : .gray.opacity(0.0))
                    .blur(radius: authManager.showVerifyAlert || authManager.showResetAlert || authManager.showResetEntry ? 0.6 : 0.0)
                }
                
                if authManager.showResetEntry {
                    VStack(spacing: 0) {
                        Text("Enter your email")
                            .font(.system(size: layoutProperties.customFontSize.small * 1.1))
                            .fontWeight(.semibold)
                            .padding(.top, 20)
                            .padding(.horizontal, 10)
                        
                        Text("Please enter the email address associated with your account.")
                            .font(.system(size: layoutProperties.customFontSize.small * 0.9))
                            .padding(.top, 5)
                            .padding(.bottom, 15)
                            .padding(.horizontal, 15)
                            .multilineTextAlignment(.center)
                        
                        TextField("", text: $authManager.resetEmail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 15)
                            .padding(.bottom, 20)
                            .textInputAutocapitalization(.never)
                        
                        Divider()
                            .frame(maxWidth: .infinity)
                            .frame(height: 0.3)
                            .background(Color.gray.opacity(0.1))
                        
                        HStack(spacing: 0) {
                            Button("Close") {
                                authManager.showResetEntry = false
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            Divider()
                                .frame(height: 40)
                                .background(Color.gray.opacity(0.01))
                            Button("Send") {
                                authManager.showResetEntry = false
                                authManager.showResetAlert = true
                                authManager.sendResetEmail(firstSend: true)
                            }
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                            .padding(10)
                        }
                        .foregroundStyle(Color.darkAccent)
                        .font(.system(size: layoutProperties.customFontSize.small * 1.1))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, y: 5)
                    .padding(.horizontal, 50)
                    .padding(.top, 60)
                }
                
                if authManager.showVerifyAlert || authManager.showResetAlert {
                    let alertTitle = "Check your inbox!"
                    let alertText = authManager.showVerifyAlert ? "We've sent you a verification email. Please click the link inside to verify your email. The screen will update automatically once verified." : "If an account exists with this email, you will receive a link to reset your password."
                    
                        VStack(spacing: 0) {
                            Text(alertTitle)
                                .font(.system(size: layoutProperties.customFontSize.small * 1.1))
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
                                .font(.system(size: layoutProperties.customFontSize.small * 0.9))
                                .padding(.top, 10)
                                .padding(.bottom, 17.5)
                                .padding(.horizontal, 15)
                                .multilineTextAlignment(.center)
                            } else {
                                Text(alertText)
                                .font(.system(size: layoutProperties.customFontSize.small * 0.9))
                                .padding(.top, 5)
                                .padding(.bottom, 15)
                                .padding(.horizontal, 15)
                                .multilineTextAlignment(.center)
                            }
                            
                            if authManager.resent {
                                Text("Email has been resent!")
                                    .font(.system(size: layoutProperties.customFontSize.small * 0.9))
                                    .foregroundStyle(Color.darkAccent)
                                    .padding(.top, -10)
                                    .padding(.bottom, 10)
                                    .padding(.horizontal, 15)
                                    .multilineTextAlignment(.center)
                            } else if authManager.showVerifyAlert && !authManager.verifyErrorText.isEmpty {
                                Text(authManager.verifyErrorText)
                                    .font(.system(size: layoutProperties.customFontSize.small * 0.9))
                                    .foregroundStyle(Color.darkAccent)
                                    .padding(.top, -10)
                                    .padding(.bottom, 10)
                                    .padding(.horizontal, 15)
                                    .multilineTextAlignment(.center)
                            } else if authManager.showResetAlert && !authManager.resetErrorText.isEmpty {
                                Text(authManager.resetErrorText)
                                    .font(.system(size: layoutProperties.customFontSize.small * 0.9))
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
                                        authManager.sendResetEmail(firstSend: false)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                                .padding(10)
                                .disabled(authManager.showVerifyTimeout)
                            }
                            .foregroundStyle(authManager.showVerifyTimeout ? dark : Color.darkAccent)
                            .font(.system(size: layoutProperties.customFontSize.small * 1.1))
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 4, y: 4)
                        .padding(.horizontal, 50)
                }
            }
            .navigationDestination(isPresented: $authManager.isVerified) {
                VerificationView(layoutProperties: layoutProperties)
            }
            .navigationDestination(isPresented: $authManager.goToHomepage) {
                HomepageView(layoutProperties: layoutProperties)
                    .onAppear {
                        if let userId = authManager.getCurrentUserId() {
                            themeManager.fetchTheme(userId: userId)
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveLayout { layoutProperties in
            LoginView(layoutProperties: layoutProperties)
                .environmentObject(AuthManager())
                .environmentObject(ThemeManager())
                .environmentObject(Entries())
        }
    }
}

