//
//  LoginView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-02-28.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var signUp: Bool = true
    @State private var logoScale: CGFloat = 1.0
    @State private var logoOffsetY: CGFloat = 0.0
    @State private var goToHomepage: Bool = false
    @State private var showAnimation: Bool
    @State private var animationCompleted: Bool
    
    let layoutProperties: LayoutProperties
    
    init(animationCompleted: Bool, layoutProperties: LayoutProperties) {
        self._showAnimation = State(initialValue: !animationCompleted)
        self._animationCompleted = State(initialValue: animationCompleted)
        self.layoutProperties = layoutProperties
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                                .padding(.bottom, -5)
                            TextField("", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 15)
                                
                            Text("Password")
                                .padding(.bottom, -5)
                            TextField("", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 15)
                            
                            if signUp {
                            Text("Confirm password")
                                .padding(.bottom, -5)
                            TextField("", text: $confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 10)
                            }
                        }
                        .boxStyle(foregroundStyle: .black, background: .white, shadowColor: .gray)
                        .font(.system(size: layoutProperties.customFontSize.small))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        HStack(spacing: 20) {
                            Button("Login") {
                                signUp = false;
                            }
                            .boxStyle(foregroundStyle: signUp ? .black : .white, background: signUp ? .white : Color.darkAccent, shadowColor: .gray)
                            
                            Button("Sign up") {
                                signUp = true;
                            }
                            .boxStyle(foregroundStyle: signUp ? .white : .black, background: signUp ? Color.darkAccent : .white, shadowColor: .gray)
                        }
                        .font(.system(size: layoutProperties.customFontSize.small))
                    }
                    .padding()
                }
                
                Image("Logo3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: logoOffsetY)
                    .scaleEffect(logoScale)
                    .onAppear {
                        if !animationCompleted {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeOut(duration: 1.5)) {
                                    logoScale = 0.8
                                    logoOffsetY = -UIScreen.main.bounds.height / 3.6
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    goToHomepage = true
                                    animationCompleted = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        showAnimation = false
                                    }
                                }
                            }
                        } else {
                            logoScale = 0.8
                            logoOffsetY = -UIScreen.main.bounds.height / 3.6
                        }
                    }
            }
        }
    }
        
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveView { layoutProperties in
            LoginView(animationCompleted: false, layoutProperties: layoutProperties)
        }
        .environmentObject(Entries())
    }
}

