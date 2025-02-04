//
//  Intro.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-24.
//

import SwiftUI

struct Homepage: View {
    @EnvironmentObject var entries: Entries
    @State private var logoScale: CGFloat = 1.0
    @State private var logoOffsetY: CGFloat = 0.0
    @State private var goToHomepage: Bool = false
    @State private var showAnimation: Bool
    @State private var animationCompleted: Bool
    
    init(animationCompleted: Bool) {
        self._showAnimation = State(initialValue: !animationCompleted)
        self._animationCompleted = State(initialValue: animationCompleted)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if !showAnimation {
                    VStack {
                        HStack {
                            Image(systemName: "person.fill")
                            Spacer()
                            Image(systemName: "info.circle.fill")
                        }
                        .font(.largeTitle)
                        .padding(.horizontal, 20)
                        .foregroundColor(Color.accentColor)
                        Spacer()
                            
                        VStack {
                            NavigationLink("Timer", destination: TimerEntry(cuetimer: false))
                            .boxStyle(
                                foregroundStyle: .white,
                                background: Color.accentColor,
                                shadowColor: .black
                            )
                            .padding(.bottom, 30)
                            NavigationLink("Exercise cues", destination: CueEntry(cuetimer: false))
                            .boxStyle(
                                foregroundStyle: .white,
                                background: Color.accentColor,
                                shadowColor: .black
                            )
                            .padding(.bottom, 30)
                            NavigationLink("CueTimer", destination: CueEntry(cuetimer: true))
                            .boxStyle(
                                foregroundStyle: .black,
                                background: .white,
                                shadowColor: .black
                            )
                            .padding(.bottom, 30)
                        }
                        .font(.title2)
                        .padding(.horizontal, 80)
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
                        if !animationCompleted {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeOut(duration: 2)) {
                                    logoScale = 0.644
                                    logoOffsetY = -UIScreen.main.bounds.height / 2.984
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    goToHomepage = true
                                    animationCompleted = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        showAnimation = false
                                    }
                                }
                            }
                        } else {
                            logoScale = 0.644
                            logoOffsetY = -UIScreen.main.bounds.height / 2.984
                        }
                    }
            }
        }
        .onAppear {
            entries.reset()
        }
        .navigationBarBackButtonHidden(true)
        .environmentObject(entries)
    }
}

struct Intro_Previews: PreviewProvider {
    static var previews: some View {
        Homepage(animationCompleted: false).environmentObject(Entries())
    }
}

class Entries: ObservableObject {
    @Published var exercises: [ExerciseEntry] = []
    @Published var timer: Timer = Timer(workPeriods: [30])
    
    func reset() {
        exercises = []
        timer = Timer(workPeriods: [30])
    }
}

