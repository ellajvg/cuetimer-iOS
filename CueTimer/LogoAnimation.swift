//
//  LogoCreator.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-13.
//

import SwiftUI

struct LogoAnimation: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var progress: CGFloat = 0.0
    @State private var showStopper: Bool = false
    @State private var logoScale: CGFloat = 1.0
    @State private var logoOffsetY: CGFloat = 0.0
    
    @Binding var showAnimation: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.white, style: StrokeStyle(lineWidth: 43))
                .rotationEffect(.degrees(-90))
                .shadow(color: .gray.opacity(0.5), radius: 4, y: 5)
            
            Circle()
                .trim(from: 0.0, to: 0.5)
                .stroke(authManager.showVerifyAlert || authManager.showResetAlert ? Color(red: 80/256, green: 80/256, blue: 80/256) : themeManager.theme.darkColor, style: StrokeStyle(
                    lineWidth: 43,
                    lineCap: .round,
                    lineJoin: .miter
                ))
                .rotationEffect(.degrees(-90))
          
            Circle()
                .trim(from: 0.5, to: 0.75)
                .stroke(.white, style: StrokeStyle(
                    lineWidth: 43,
                    lineCap: .butt,
                    lineJoin: .miter
                ))
            
            Rectangle()
                    .frame(height: 60)
                    .frame(width: 15)
                    .offset(y: -106)
                    .transition(.opacity)
        }
        .padding(90)
        .onAppear {
            if showAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        logoScale = 0.8
                        logoOffsetY = -UIScreen.main.bounds.height / 3.6
                        showAnimation = false
                    }
                }
            }
        }
        .offset(y: showAnimation ? logoOffsetY : -UIScreen.main.bounds.height / 3.6)
        .scaleEffect(showAnimation ? 1.0 : 0.8)
    }
}


