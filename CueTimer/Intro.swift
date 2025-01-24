//
//  Intro.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-24.
//

import SwiftUI


struct Intro: View {
    @State private var timerOffset: CGFloat = -UIScreen.main.bounds.width
    @State private var showCue = true
    
    var body: some View {
        ZStack {
            Image("Timer")
                .resizable()
                .frame(width: 650, height: 300)
                .aspectRatio(contentMode: .fit)
                .offset(x: timerOffset, y: -2)
                .animation(.easeInOut(duration: 0.5), value: timerOffset)
            
            if showCue {
                Image("Cue")
                    .resizable()
                    .frame(width: 1100, height: 650)
                    .aspectRatio(contentMode: .fit)
                    .offset(x: -54, y: -47.5)
                    .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation {
                timerOffset = 20
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    timerOffset = UIScreen.main.bounds.width
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        showCue = false
                    }
                }
            }
        }
    }
}

struct Intro_Previews: PreviewProvider {
    static var previews: some View {
        Intro()
    }
}
