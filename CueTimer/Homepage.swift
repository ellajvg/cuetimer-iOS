//
//  Intro.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-24.
//

import SwiftUI

struct Homepage: View {
    @State private var logoScale: CGFloat = 1.0
    @State private var logoOffsetY: CGFloat = 0.0
    @State private var goToHomepage = false
    @State private var showAnimation = true

    var body: some View {
        ZStack {
            if !showAnimation {
                VStack {
                    HStack {
                        Image(systemName: "house.fill")
                        Spacer()
                        Image(systemName: "person.fill")
                    }
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)
                    .foregroundColor(Color.accentColor)
                    Spacer()
                        
                    VStack {
                        Button("Timer") {
                                
                        }.buttonStyle(
                            foregroundStyle: .white,
                            background: Color.accentColor
                        )
                        .padding(.bottom, 30)
                            
                        Button("Exercise cues") {
                                
                        }.buttonStyle(
                            foregroundStyle: .white,
                            background: Color.accentColor
                        )
                        .padding(.bottom, 30)
                            
                        Button("CueTimer") {
                                
                        }
                        .buttonStyle(
                            foregroundStyle: .black,
                            background: .white
                        )
                        .padding(.bottom, 30)
                    }
                    .padding(.bottom, 30)
                }
                .background(
                    Image("Background")
                        .ignoresSafeArea()
                        .offset(y:250)
                )
                
            }
            Image("Logo3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(y: logoOffsetY)
                .scaleEffect(logoScale)
                .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 2)) {
                        logoScale = 0.644
                        logoOffsetY = -UIScreen.main.bounds.height / 2.984
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        goToHomepage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showAnimation = false
                        }
                    }
                }
            }
        }
    }
}

struct Intro_Previews: PreviewProvider {
    static var previews: some View {
        Homepage()
    }
}
