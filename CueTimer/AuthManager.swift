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
    @Published var showResetPopover: Bool = false
    @Published var goToHomepage: Bool = false
    @Published var email: String = ""
    @Published var confirmEmail: String = ""
    @Published var resetEmail: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var showResetAlert: Bool = false
    @Published var showVerifyAlert: Bool = false
    @Published var showVerifyTimeout: Bool = false
    @Published var verifyErrorText: String = ""
    @Published var showResetError: Bool = false
    @Published var resetErrorText: String = ""
    @Published var resent: Bool = false
    
    @Published var showEmailError: Bool = false
    @Published var showLengthError: Bool = false
    @Published var showMatchError: Bool = false
    @Published var showDefaultError: Bool = false
    @Published var emailErrorText: String = ""
    @Published var defaultErrorText: String = ""
    
    @Published var deleteText: String = ""
    @Published var showAccountPopover: Bool = false
    @Published var showConfirmation: Bool = false
    @Published var isLoggedOut: Bool = false
    
    private let db = Firestore.firestore()
    private var authListener: AuthStateDidChangeListenerHandle?
    
    init() {
        listenForAuthChanges()
    }
    
    deinit {
        if let authListener = authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }
    
    func listenForAuthChanges() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                if user == nil {
                    self?.isLoggedOut = true
                    self?.showVerifyAlert = false
                    self?.verifyErrorText = ""
                    self?.clearFields()
                    self?.showAccountPopover = false
                }
            }
        }
    }
    
    func clearFields() {
        self.goToHomepage = false
        self.email = ""
        self.confirmEmail = ""
        self.password = ""
        self.confirmPassword = ""
        self.showEmailError = false
        self.showLengthError = false
        self.showMatchError = false
        self.showDefaultError = false
        self.emailErrorText = ""
        self.verifyErrorText = ""
        self.resetErrorText = ""
        self.defaultErrorText = ""
        self.showConfirmation = false
    }
    
    func hasCurrentUser() -> Bool {
        guard let user = Auth.auth().currentUser else {
            return false
        }
        return user.isEmailVerified
    }
    
    func getUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func getUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
     
    func reauthenticate(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            self.defaultErrorText = "Oops! An error occurred authenticating your account. Please logout and try again."
            self.showDefaultError = true
            completion(false)
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: self.email, password: self.password)

        user.reauthenticate(with: credential) { result, error in
            if error != nil {
                self.defaultErrorText = "Email or password is incorrect."
                self.showDefaultError = true
                completion(false)
            } else {
                completion(true)
                self.clearFields()
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: self.email, password: self.password) { result, error in
            if let error = error {
                self.defaultErrorText = "Email or password is incorrect."
                self.showDefaultError = true
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if Auth.auth().currentUser?.isEmailVerified == false {
                self.sendVerificationEmail(firstSend: true)
            }
            self.clearFields()
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { result, error in
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
            self.db.collection("users").document(userId).setData(["createdAt": Timestamp()], merge: true)
            
            self.sendVerificationEmail(firstSend: true)
            self.clearFields()
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
            self.checkEmailVerification()
        }
    }
    
    func sendResetEmail(firstSend: Bool, completion: @escaping (Bool) -> Void) {
        self.showResetError = false
        self.resetErrorText = ""
        Auth.auth().sendPasswordReset(withEmail: self.resetEmail) { error in
            if let error = error {
                self.resetErrorText = "Error: \(error.localizedDescription)"
                self.showResetError = true
                completion(false)
                return
            }
            
            if !firstSend {
                self.resent = true
            }
            
            completion(true)
        }
    }
    
    func checkEmailVerification() {
        self.showVerifyTimeout = false
        guard let user = Auth.auth().currentUser else { return }
        var counter = 0
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            counter += 1
            if counter > 150 {
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
                    self.showVerifyAlert = false
                    timer.invalidate()
                }
            }
        }
    }
    
    func updateEmail() {
        guard let user = Auth.auth().currentUser else {
            self.defaultErrorText = "Oops! An error occurred authenticating your account. Please logout and try again."
            self.showDefaultError = true
            return
        }
        
        user.sendEmailVerification(beforeUpdatingEmail: self.email) { error in
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
            self.showVerifyAlert = true
        }
    }
    
    func updatePassword() {
        Auth.auth().currentUser?.updatePassword(to: self.password) { error in
            if let error = error {
                self.defaultErrorText = "Error: \(error.localizedDescription)"
                self.showDefaultError = true
            }
            self.showConfirmation = true
        }
    }
        
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            self.defaultErrorText = "Error: \(error.localizedDescription)"
            self.showDefaultError = true
        }
    }
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }
        
        let userId = user.uid
        let userDocRef = self.db.collection("users").document(userId)
        
        userDocRef.delete { error in
            if let error = error {
                self.defaultErrorText = "Error: \(error.localizedDescription)"
                self.showDefaultError = true
                return
            }
        }
    
        user.delete { error in
          if let error = error {
              self.defaultErrorText = "Error: \(error.localizedDescription)"
              self.showDefaultError = true
          } 
        }
    }
}


