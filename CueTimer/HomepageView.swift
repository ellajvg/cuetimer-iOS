//
//  Intro.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-24.
//

import SwiftUI
import FirebaseAuth

struct HomepageView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @State private var selection: String? = nil
    @State private var logoScale: CGFloat = 1.0
    @State private var logoOffsetY: CGFloat = 0.0
    @State private var progress: CGFloat = 0.0
    @State private var showAnimation: Bool
    
    @State private var goToCueTimerEntry: Bool = false
    @State private var goToCueEntry: Bool = false
    @State private var goToTimerEntry: Bool = false
    
    init(showAnimation: Bool = false) {
        self.showAnimation = showAnimation
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            authManager.showAccountPopover = true
                        } label: {
                            if !showAnimation {
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .foregroundColor(themeManager.theme.darkColor)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .animation(.easeIn(duration: 0.3), value: showAnimation)
                    
                    Spacer()
                }
                if !showAnimation {
                        VStack {
                            Spacer()
                            Button {
                                workoutManager.totalReset()
                                workoutManager.cuetimer = true
                                workoutManager.goToCueTimerEntry = true
                            } label:  {
                                Text("CueTimer")
                                    .boxStyle(
                                        foregroundStyle: .white,
                                        background: themeManager.theme.darkColor,
                                        shadowColor: themeManager.theme.shadowColor
                                    )
                            }
                            .growingButton()
                            .padding(.bottom, 30)
                            Button {
                                workoutManager.totalReset()
                                workoutManager.goToTimerEntry = true
                            } label: {
                                Text("Timer")
                                    .boxStyle(
                                        foregroundStyle: .black,
                                        background: .white,
                                        shadowColor: themeManager.theme.shadowColor
                                    )
                            }
                            .growingButton()
                            .padding(.bottom, 30)
                            Button {
                                workoutManager.totalReset()
                                workoutManager.goToCueEntry = true
                            } label: {
                                Text("Exercise cues")
                                    .boxStyle(
                                        foregroundStyle: .black,
                                        background: .white,
                                        shadowColor: themeManager.theme.shadowColor
                                    )
                            }
                            .growingButton()
                            .padding(.bottom, 30)
                        }
                        .font(.title3)
                        .padding(.horizontal, 80)
                    
                    .background(
                        VStack {
                            Spacer()
                            Circle()
                                .fill(themeManager.theme.lightColor)
                                .scaleEffect(2.3)
                                .offset(y: 260)
                        }
                            .ignoresSafeArea()
                    )
                    .transition(AnyTransition.move(edge: .bottom))
                }
                
                LogoAnimation(showAnimation: $showAnimation)
            }
            .ignoresSafeArea(.keyboard)
            .navigationDestination(isPresented: $workoutManager.goToCueTimerEntry) {
                CueEntryView(cuetimer: true)
            }
            .navigationDestination(isPresented: $workoutManager.goToCueEntry) {
                CueEntryView(cuetimer: false)
            }
            .navigationDestination(isPresented: $workoutManager.goToTimerEntry) {
                TimerEntryView(cuetimer: false, cuesModified: false)
            }
            .navigationDestination(isPresented: $goToCueTimerEntry) {
                CueEntryView(cuetimer: true)
            }
            .navigationDestination(isPresented: $goToCueEntry) {
                CueEntryView(cuetimer: false)
            }
            .navigationDestination(isPresented: $goToTimerEntry) {
                TimerEntryView(cuetimer: false, cuesModified: false)
            }
            .navigationDestination(isPresented: $workoutManager.goToCueTimerWorkout) {
                CueTimerView(cuetimer: workoutManager.cuetimer)
            }
            .navigationDestination(isPresented: $workoutManager.goToCueWorkout) {
                CueWorkoutView(cuetimer: false)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func incrementProgress() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if progress == 0.5 {
                timer.invalidate()
                return
            }
            progress += 0.1
        }
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView(showAnimation: true)
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}



