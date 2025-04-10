//
//  AuthFieldsView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-20.
//

import SwiftUI

struct AuthFieldsView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .padding(.bottom, -5)
            
            TextField("", text: $authManager.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
                .textInputAutocapitalization(.never)
                .onChange(of: authManager.email) { oldValue, newValue in
                    authManager.showDefaultError = false
                    authManager.email = newValue.filter { !$0.isWhitespace }
                    if authManager.showEmailError && oldValue != newValue {
                        authManager.showEmailError = false
                    }
                }
            
            Text("Password")
                .padding(.bottom, -5)
            
            SecureField("", text: $authManager.password)
                .textContentType(.oneTimeCode)
                .autocorrectionDisabled(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
                .textInputAutocapitalization(.never)
                .onChange(of: authManager.password) { oldValue, newValue in
                    authManager.password = newValue.filter { !$0.isWhitespace }
                }
        }
    }
}
