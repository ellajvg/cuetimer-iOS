//
//  DeleteAccountView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-20.
//

import SwiftUI

struct DeleteAccountView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var goToSettings: Bool = false
    @State private var showNextStep: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Delete account")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                    
                    if showNextStep {
                        Text("WARNING: Deleting your account is a permanent action and cannot be undone.")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                    }
                    
                    Text(showNextStep ? "To proceed, please type DELETE in the textfield below and click delete account." : "Please enter your current login credentials and click next.")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    
                    if !showNextStep {
                        AuthFieldsView()
                    } else if showNextStep {
                        TextField("", text: $authManager.deleteText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                            .textInputAutocapitalization(.never)
                            .onChange(of: authManager.deleteText) { oldValue, newValue in
                                authManager.showDefaultError = false
                                authManager.deleteText = newValue.filter { !$0.isWhitespace }
                            }
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
                    Button {
                        goToSettings = true
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
                            } else {
                                if authManager.deleteText.isEmpty {
                                    authManager.defaultErrorText = "This is a required field."
                                    authManager.showDefaultError = true
                                } else if authManager.deleteText != "DELETE" {
                                    authManager.defaultErrorText = "Input does not match what is required."
                                    authManager.showDefaultError = true
                                } else {
                                    authManager.deleteAccount()
                                }
                            }
                        }
                    } label: {
                        Text(showNextStep ? "Delete account" : "Next")
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

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView()
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}
