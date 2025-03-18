//
//  AuthManager.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-11.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthManager: ObservableObject {
    @Published var resetEmail: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isVerified = false
    @Published var goToHomepage = false
    
    @Published var showResetEntry: Bool = false
    @Published var showResetAlert: Bool = false
    @Published var showVerifyAlert: Bool = false
    @Published var showVerifyTimeout: Bool = false
    @Published var showEmailError: Bool = false
    @Published var verifyErrorText: String = ""
    @Published var resetErrorText: String = ""
    @Published var resent: Bool = false
    
    @Published var showLengthError: Bool = false
    @Published var showMatchError: Bool = false
    @Published var showDefaultError: Bool = false
    @Published var emailErrorText: String = ""
    @Published var defaultErrorText: String = ""
    
    @Published var isUserLoggedOut: Bool = false
    @Published var showLogoutAlert: Bool = false
    @Published var logoutErrorText: String = ""
    
    private let db = Firestore.firestore()
    
    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func hasCurrentUser() -> Bool {
        guard let user = Auth.auth().currentUser else {
            return false 
        }
        return user.isEmailVerified
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                self.defaultErrorText = "Email or password is incorrect."
                self.showDefaultError = true
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if Auth.auth().currentUser?.isEmailVerified == true {
                self.goToHomepage = true
            } else {
                self.sendVerificationEmail(firstSend: true)
                self.checkEmailVerification()
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                let errorCode = AuthErrorCode(rawValue: error.code)
                switch errorCode {
                    case .emailAlreadyInUse:
                        self.emailErrorText = "This email is already in use."
                        self.showEmailError = true
                    case .invalidEmail:
                        self.emailErrorText = "This email is invalid."
                        self.showEmailError = true
                    default:
                        self.defaultErrorText = "Error: \(error.localizedDescription)"
                        self.showDefaultError = true
                }
                return
            }
            
            guard let userId = result?.user.uid else { return }
            self.db.collection("users").document(userId).setData(["createdAt": Timestamp()])
            
            Auth.auth().currentUser?.sendEmailVerification { (error) in
                self.verifyErrorText = ""
                if let error = error {
                    self.showVerifyAlert = true
                    self.verifyErrorText = "Error: \(error.localizedDescription)"
                } else {
                    self.showVerifyAlert = true
                }
            }
            
            self.checkEmailVerification()
        }
    }
    
    func sendVerificationEmail(firstSend: Bool) {
        self.verifyErrorText = ""
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            if let error = error {
                self.verifyErrorText = "Error: \(error.localizedDescription)"
            } else if !firstSend {
                self.resent = true
            }
            self.showVerifyAlert = true
        }
    }
    
    func sendResetEmail(firstSend: Bool) {
        self.resetErrorText = ""
        Auth.auth().sendPasswordReset(withEmail: resetEmail) { error in
            if let error = error {
                self.resetErrorText = "Error: \(error.localizedDescription)"
            } else if !firstSend {
                self.resent = true
            }
        }
    }
    
    func checkEmailVerification() {
        self.showVerifyTimeout = false
        guard let user = Auth.auth().currentUser else { return }
        var counter = 0
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            counter += 1
            if counter > 5 {
                timer.invalidate()
                self.showVerifyTimeout = true
                return
            }
            
            user.reload { error in
                if let error = error {
                    timer.invalidate()
                    self.verifyErrorText = "Error: \(error.localizedDescription)"
                    return
                }
                
                if user.isEmailVerified {
                    timer.invalidate()
                    DispatchQueue.main.async {
                        self.isVerified = true
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isUserLoggedOut = true
        } catch let error as NSError {
            self.logoutErrorText = "Error: \(error.localizedDescription)"
        }
    }
}


