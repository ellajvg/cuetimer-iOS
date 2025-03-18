//
//  VerificationView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-05.
//

import SwiftUI

struct VerificationView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showSuccessText = false
    @State private var showRedirectText = false
    @State private var progress: CGFloat = 0.0
    @State private var goToHomepage = false
    
    let layoutProperties: LayoutProperties
    
    var body: some View {
        NavigationStack {
            VStack {
                if showSuccessText {
                    Text("Verification successful!")
                        .font(.system(size: layoutProperties.customFontSize.large))
                        .foregroundStyle(Color.darkAccent)
                        .fontWeight(.semibold)
                        .padding()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSuccessText = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSuccessText = false
                            }
                            
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            goToHomepage = true
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $goToHomepage) {
                HomepageView(showAnimation: true, layoutProperties: layoutProperties)
                    .onAppear {
                        if let userId = authManager.getCurrentUserId() {
                            themeManager.fetchTheme(userId: userId)
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func incrementProgress() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if progress < 1.0 {
                progress += 0.25
            } else {
                timer.invalidate()
                
            }
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveLayout { layoutProperties in
            VerificationView(layoutProperties: layoutProperties)
                .environmentObject(AuthManager())
                .environmentObject(ThemeManager())
                .environmentObject(Entries())
        }
    }
}
