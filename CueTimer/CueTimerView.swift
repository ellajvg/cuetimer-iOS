//
//  CueTimerWorkout.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-31.
//

import SwiftUI

struct CueTimerView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var soundManager: SoundManager
    @Environment(\.dismiss) private var dismiss
    @State private var showExitAlert: Bool = false
    @State private var showEditAlert: Bool = false
    @State private var navigateToTimerEntry: Bool = false
    
    private var dark: Color { showEditAlert || showExitAlert ? Color(red: 80/256, green: 80/256, blue: 80/256) : themeManager.theme.darkColor }
    
    private var light: Color { showEditAlert || showExitAlert ? Color(red: 232/256, green: 232/256, blue: 232/256) : themeManager.theme.lightColor }
    
    let cuetimer: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            workoutManager.stopTimer()
                            if workoutManager.totalRemainingTime == 0 {
                                workoutManager.totalReset()
                                dismiss()
                            } else {
                                showExitAlert = true
                            }
                        } label: {
                            Image(systemName: "house.fill")
                                .font(.title)
                                .foregroundColor(dark)
                        }
                        Spacer()
                        Button {
                            workoutManager.stopTimer()
                            showEditAlert = true
                        } label: {
                            Image(systemName: "pencil.line")
                                .font(.title)
                                .foregroundColor(dark)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 30)
                            .foregroundStyle(light)
                        Circle()
                            .trim(from: workoutManager.endOfSegment ? 1.0 : 0.0, to: workoutManager.endOfSegment ? 1.0 : workoutManager.progress)
                            .stroke(getTimerColor(), style: StrokeStyle(
                                lineWidth: 30,
                                lineCap: .round,
                                lineJoin: .miter
                            ))
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text(displayTime(time: workoutManager.remainingTime))
                                .monospacedDigit()
                                .font(.system(size: 100))
                                .foregroundStyle(dark)
                                .bold()
                                .contentTransition(.numericText())
                            Text(displayTime(time: workoutManager.totalRemainingTime))
                                .monospacedDigit()
                                .font(.title)
                                .foregroundStyle(dark)
                                .animation(.linear(duration: 0.2), value: workoutManager.totalRemainingTime)
                        }
                        .onChange(of: workoutManager.remainingTime) {
                            if soundManager.sound {
                                if workoutManager.remainingTime == 3 {
                                    soundManager.playSound(name: "Countdown")
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        soundManager.playSound(name: "Countdown")
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        soundManager.playSound(name: "Countdown")
                                    }
                                } else if workoutManager.timerSegments[workoutManager.timerCurr].work && workoutManager.timeElapsed == 0 {
                                    soundManager.playSound(name: "Start", shouldDeactivateAfter: true)
                                } else if (workoutManager.timerCurr != 0 && workoutManager.timeElapsed == 0) || workoutManager.remainingTime == 0 {
                                    soundManager.playSound(name: "Complete", shouldDeactivateAfter: true)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .animation(.linear(duration: 1.0), value: workoutManager.progress)
                    Spacer()
                    VStack(spacing: 15) {
                        if cuetimer {
                            if !workoutManager.cues.isEmpty && workoutManager.cueCurr == 0{
                                Text(workoutManager.cues[workoutManager.cueCurr].exercise)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .frame(height: 100)
                                    .boxStyle(foregroundStyle: .white, background: dark, shadowColor: .white)
                            } else if !workoutManager.timerSegments[workoutManager.timerCurr].work {
                                Text("Rest")
                                    .font(.largeTitle)
                                    .multilineTextAlignment(.center)
                                    .frame(height: 100)
                                    .boxStyle(foregroundStyle: .white, background: dark, shadowColor: .white)
                            } else if workoutManager.cueCurr < workoutManager.total {
                                VStack {
                                    Spacer()
                                    Text(workoutManager.cues[workoutManager.cueCurr].exercise)
                                        .font(.title)
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                    HStack {
                                        Text(workoutManager.cues[workoutManager.cueCurr].set!)
                                        Spacer()
                                        if workoutManager.cues[workoutManager.cueCurr].side != nil {
                                            Text(workoutManager.cues[workoutManager.cueCurr].side!)
                                            Spacer()
                                        }
                                        if workoutManager.cues[workoutManager.cueCurr].reps != "Reps: 0" {
                                            Text(workoutManager.cues[workoutManager.cueCurr].reps!)
                                        }
                                    }
                                    
                                }
                                .padding(5)
                                .frame(height: 100)
                                .boxStyle(foregroundStyle: .white, background: dark, shadowColor: .white)
                            } else {
                                VStack {
                                    Text("Workout complete!")
                                        .font(.title)
                                }
                                .frame(height: 100)
                                .boxStyle(foregroundStyle: .white, background: dark, shadowColor: .white)
                                .onAppear {
                                    if workoutManager.name != nil {
                                        if let userId = authManager.getUserId() {
                                            dataManager.updateLastCompleted(userId: userId, name: workoutManager.name!)
                                        }
                                    }
                                }
                            }
                            VStack {
                                Text(workoutManager.findNextExercise())
                            }
                            .boxStyle(
                                foregroundStyle: .black,
                                background: light,
                                shadowColor: .white
                            )
                        } else {
                            VStack {
                                if workoutManager.timerCurr == 0 {
                                    Text("Get ready!")
                                        .font(.title)
                                } else if workoutManager.totalRemainingTime == 0 {
                                    Text("Workout Complete!")
                                        .font(.title)
                                        .onAppear {
                                            if workoutManager.name != nil {
                                                if let userId = authManager.getUserId() {
                                                    dataManager.updateLastCompleted(userId: userId, name: workoutManager.name!)
                                                }
                                            }
                                        }
                                } else if workoutManager.timerSegments[workoutManager.timerCurr].work {
                                    Text("Work")
                                        .font(.largeTitle)
                                } else if !workoutManager.timerSegments[workoutManager.timerCurr].work {
                                    Text("Rest")
                                        .font(.largeTitle)
                                }
                            }
                            .multilineTextAlignment(.center)
                            .frame(height: 80)
                            .boxStyle(foregroundStyle: .white, background: dark, shadowColor: .white)
                            
                            VStack {
                                if workoutManager.timerCurr == 0 {
                                    Text("You got this :)")
                                } else if workoutManager.totalRemainingTime == 0 {
                                    Text("Go flex in the mirror :)")
                                } else {
                                    Text("Round \(workoutManager.timerSegments[workoutManager.timerCurr].index) of \(workoutManager.timerEntry.repeats)")
                                }
                            }
                            .boxStyle(
                                foregroundStyle: .black,
                                background: light,
                                shadowColor: .white
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    HStack {
                        Button {
                            workoutManager.goToPreviousTimer()
                        } label: {
                            Image(systemName: "arrowshape.backward.fill")
                        }
                        .foregroundStyle(workoutManager.previousTimerButtonDisabled ? light : dark)
                        .disabled(workoutManager.previousTimerButtonDisabled)
                        Spacer()
                        HStack(spacing: 20) {
                            Button {
                                workoutManager.startTimer()
                            } label: {
                                Image(systemName: "play.fill")
                            }
                            .foregroundStyle(workoutManager.playButtonDisabled ? light : dark)
                            .disabled(workoutManager.playButtonDisabled)
                            Button {
                                workoutManager.stopTimer()
                            } label: {
                                Image(systemName: "pause.fill")
                            }
                            .foregroundStyle(workoutManager.pauseButtonDisabled ? light : dark)
                            .disabled(workoutManager.pauseButtonDisabled)
                        }
                        Spacer()
                        Button {
                            workoutManager.goToNextTimer()
                        } label: {
                            Image(systemName: "arrowshape.forward.fill")
                        }
                        .foregroundStyle(workoutManager.nextButtonDisabled ? light : dark)
                        .disabled(workoutManager.nextButtonDisabled)
                    }
                    .padding(.horizontal, 21)
                    .padding(.bottom, 10)
                    .font(.largeTitle)
                }
                .overlay(showEditAlert || showExitAlert ? .gray.opacity(0.3) : .gray.opacity(0.0))
                .blur(radius: showEditAlert || showExitAlert ? 0.6 : 0.0)
                
                if showEditAlert || showExitAlert {
                    let alertTitle = "Progress will be lost"
                    let alertText = showEditAlert ? "Still want to edit this workout?" : "Still want to exit this workout?"
                    VStack(spacing: 0) {
                        Text(alertTitle)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.top, 20)
                            .padding(.horizontal, 10)
                            
                        Text(alertText)
                            .padding(.top, 5)
                            .padding(.bottom, 15)
                            .padding(.horizontal, 15)
                            .multilineTextAlignment(.center)
                        
                        Divider()
                            .frame(maxWidth: .infinity)
                            .frame(height: 0.3)
                            .background(Color.gray.opacity(0.1))
                       
                       
                        HStack(spacing: 0) {
                            Button("No") {
                                showEditAlert = false
                                showExitAlert = false
                            }
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            Divider()
                                .frame(height: 40)
                                .background(Color.gray.opacity(0.01))
                            Button("Yes") {
                                if showEditAlert {
                                    showEditAlert = false
                                    workoutManager.partialReset()
                                    navigateToTimerEntry = true
                                } else {
                                    showExitAlert = false
                                    workoutManager.totalReset()
                                    dismiss()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                        }
                        .foregroundStyle(themeManager.theme.darkColor)
                        .font(.title3)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, y: 5)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 60)
                }
            }
            .navigationDestination(isPresented: $navigateToTimerEntry) {
                TimerEntryView(cuetimer: cuetimer, cuesModified: false)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            workoutManager.startTimer()
        }
    }
    
    func displayTime(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%01d:%02d", minutes, seconds)
    }
    
    func getTimerColor() -> Color {
        if workoutManager.endOfSegment {
            if workoutManager.timerSegments[workoutManager.timerCurr - 1].work {
                return dark
            } else {
                return dark.opacity(0.3)
            }
        } else if workoutManager.timerSegments[workoutManager.timerCurr].work {
            return dark
        } else {
            return dark.opacity(0.3)
        }
    }
}

struct CueTimerWorkout_Previews: PreviewProvider {
    static var previews: some View {
        CueTimerView(cuetimer: false)
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
            .environmentObject(SoundManager())
    }
}
