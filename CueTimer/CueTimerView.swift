//
//  CueTimerWorkout.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-31.
//

import SwiftUI

struct CueTimerView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var entries: Entries
    @ObservedObject var timerWorkout: TimerWorkout
    
    @State private var showExitAlert: Bool = false
    @State private var showEditAlert: Bool = false
    @State private var navigateToHomepage: Bool = false
    @State private var navigateToTimerEntry: Bool = false
    
    private var dark: Color { showEditAlert || showExitAlert ? Color(red: 80/256, green: 80/256, blue: 80/256) : themeManager.theme.darkColor }
    
    private var light: Color { showEditAlert || showExitAlert ? Color(red: 232/256, green: 232/256, blue: 232/256) : themeManager.theme.lightColor }
    
    let cuetimer: Bool
    let layoutProperties: LayoutProperties
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(lineWidth: layoutProperties.customDimensValue.small)
                            .foregroundStyle(light)
                        Circle()
                            .trim(from: timerWorkout.endOfSegment ? 1.0 : 0.0, to: timerWorkout.endOfSegment ? 1.0 : timerWorkout.progress)
                            .stroke(getTimerColor(), style: StrokeStyle(
                                lineWidth: layoutProperties.customDimensValue.small,
                                lineCap: .round,
                                lineJoin: .miter
                            ))
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text(displayTime(time: timerWorkout.remainingTime))
                                .monospacedDigit()
                                .font(.system(size: layoutProperties.customFontSize.giant))
                                .foregroundStyle(dark)
                                .bold()
                                .contentTransition(.numericText())
                            Text(displayTime(time: timerWorkout.totalRemainingTime))
                                .monospacedDigit()
                                .font(.system(size: layoutProperties.customFontSize.mediumLarge))
                                .foregroundStyle(dark)
                                .animation(.linear(duration: 0.2), value: timerWorkout.totalRemainingTime)
                        }
                    }
                    .padding(.horizontal, layoutProperties.customDimensValue.smallMedium)
                    .animation(.linear(duration: 1.0), value: timerWorkout.progress)
                    Spacer()
                    VStack(spacing: 15) {
                        if cuetimer {
                            if timerWorkout.cueWorkout.curr == 0 {
                                Text(timerWorkout.cueWorkout.cues[timerWorkout.cueWorkout.curr].exercise)
                                    .font(.system(size: layoutProperties.customFontSize.large))
                                    .multilineTextAlignment(.center)
                                    .frame(height: 110)
                                    .boxStyle(foregroundStyle: .white, background: dark, shadowColor: .white)
                            } else if !timerWorkout.timerSegments[timerWorkout.curr].work {
                                Text("Rest")
                                    .font(.system(size: layoutProperties.customFontSize.large))
                                    .padding(.bottom, layoutProperties.customFontSize.small * 1.2)
                                    .multilineTextAlignment(.center)
                                    .frame(height: 110)
                                    .boxStyle(foregroundStyle: .white, background: dark, shadowColor: .white)
                            } else if timerWorkout.cueWorkout.curr < timerWorkout.cueWorkout.total {
                                VStack {
                                    Spacer()
                                    Text(timerWorkout.cueWorkout.cues[timerWorkout.cueWorkout.curr].exercise)
                                        .font(.system(size: layoutProperties.customFontSize.medium))
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                    HStack {
                                        Text(timerWorkout.cueWorkout.cues[timerWorkout.cueWorkout.curr].set!)
                                        Spacer()
                                        if timerWorkout.cueWorkout.cues[timerWorkout.cueWorkout.curr].side != nil {
                                            Text(timerWorkout.cueWorkout.cues[timerWorkout.cueWorkout.curr].side!)
                                            Spacer()
                                        }
                                        
                                        Text(timerWorkout.cueWorkout.cues[timerWorkout.cueWorkout.curr].reps!)
                                    }
                                    .font(.system(size: layoutProperties.customFontSize.small))
                                    
                                }
                                .padding(5)
                                .frame(height: 110)
                                .boxStyle(foregroundStyle: .white, background: dark, shadowColor: .white)
                            } else {
                                VStack {
                                    Text("Workout complete!")
                                        .font(.system(size: layoutProperties.customFontSize.large))
                                }
                                .frame(height: 110)
                                .boxStyle(foregroundStyle: .white, background: dark, shadowColor: .white)
                            }
                            VStack {
                                Text(timerWorkout.cueWorkout.findNextExercise())
                                    .font(.system(size: layoutProperties.customFontSize.small))
                            }
                            .boxStyle(
                                foregroundStyle: .black,
                                background: light,
                                shadowColor: .white
                            )
                        } else {
                            VStack {
                                if timerWorkout.curr == 0 {
                                    Text("Get ready!")
                                        .font(.system(size: layoutProperties.customFontSize.large))
                                } else if timerWorkout.totalRemainingTime == 0 {
                                    Text("Workout Complete!")
                                        .font(.system(size: layoutProperties.customFontSize.large))
                                } else if timerWorkout.timerSegments[timerWorkout.curr].work {
                                    Text("Work")
                                        .font(.system(size: layoutProperties.customFontSize.large * 1.2))
                                } else if !timerWorkout.timerSegments[timerWorkout.curr].work {
                                    Text("Rest")
                                        .font(.system(size: layoutProperties.customFontSize.large * 1.2))
                                }
                            }
                            .multilineTextAlignment(.center)
                            .frame(height: 80)
                            .boxStyle(foregroundStyle: .white, background: dark, shadowColor: .white)
                            
                            
                            VStack {
                                if timerWorkout.curr == 0 {
                                    Text("You got this :)")
                                } else if timerWorkout.totalRemainingTime == 0 {
                                    Text("Go flex in the mirror :)")
                                } else {
                                    Text("Round \(timerWorkout.timerSegments[timerWorkout.curr].index) of \(entries.timerEntry.repeats)")
                                }
                            }
                            .font(.system(size: layoutProperties.customFontSize.small))
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
                            timerWorkout.goToPreviousTimer()
                        } label: {
                            Image(systemName: "arrowshape.backward.fill")
                        }
                        .foregroundStyle(timerWorkout.previousButtonDisabled ? light : dark)
                        .disabled(timerWorkout.previousButtonDisabled)
                        Spacer()
                        HStack(spacing: 20) {
                            Button {
                                timerWorkout.startTimer()
                            } label: {
                                Image(systemName: "play.fill")
                            }
                            .foregroundStyle(timerWorkout.playButtonDisabled ? light : dark)
                            .disabled(timerWorkout.playButtonDisabled)
                            Button {
                                timerWorkout.stopTimer()
                            } label: {
                                Image(systemName: "pause.fill")
                            }
                            .foregroundStyle(timerWorkout.pauseButtonDisabled ? light : dark)
                            .disabled(timerWorkout.pauseButtonDisabled)
                        }
                        Spacer()
                        Button {
                            timerWorkout.goToNextTimer()
                        } label: {
                            Image(systemName: "arrowshape.forward.fill")
                        }
                        .foregroundStyle(timerWorkout.nextButtonDisabled ? light : dark)
                        .disabled(timerWorkout.nextButtonDisabled)
                    }
                    .padding(.horizontal, 21)
                    .padding(.bottom, 10)
                    .font(.system(size: layoutProperties.customFontSize.large))
                }
                .overlay(showEditAlert || showExitAlert ? .gray.opacity(0.3) : .gray.opacity(0.0))
                .blur(radius: showEditAlert || showExitAlert ? 0.6 : 0.0)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            timerWorkout.stopTimer()
                            if timerWorkout.totalRemainingTime == 0 {
                                navigateToHomepage = true
                            } else {
                                showExitAlert = true
                            }
                        } label: {
                            Image(systemName: "house.fill")
                                .font(.system(size: layoutProperties.customFontSize.mediumLarge))
                                .foregroundColor(dark)
                                .blur(radius: showEditAlert || showExitAlert ? 0.6 : 0.0)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            timerWorkout.stopTimer()
                            showEditAlert = true
                        } label: {
                            Image(systemName: "pencil.line")
                                .font(.system(size: layoutProperties.customFontSize.mediumLarge))
                                .foregroundColor(dark)
                                .blur(radius: showEditAlert || showExitAlert ? 0.6 : 0.0)
                        }
                        .navigationDestination(isPresented: $navigateToTimerEntry) {
                            ResponsiveLayout { layoutProperties in
                                TimerEntryView(cuetimer: cuetimer, layoutProperties: layoutProperties)
                            }
                            
                        }
                    }
                }
                
                if showEditAlert || showExitAlert {
                    let alertTitle = "Progress will be lost"
                    let alertText = showEditAlert ? "Do you still want to edit this workout?" : "Do you still want to exit this workout?"
                    VStack(spacing: 0) {
                        Text(alertTitle)
                            .font(.system(size: layoutProperties.customFontSize.small * 1.1))
                            .fontWeight(.semibold)
                            .padding(.top, 20)
                            .padding(.horizontal, 10)
                            
                        Text(alertText)
                            .font(.system(size: layoutProperties.customFontSize.small * 0.9))
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
                                    navigateToTimerEntry = true
                                } else {
                                    showExitAlert = false
                                    navigateToHomepage = true
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(10)
                        }
                        .foregroundStyle(themeManager.theme.darkColor)
                        .font(.system(size: layoutProperties.customFontSize.small * 1.1))
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
            .navigationDestination(isPresented: $navigateToHomepage) {
                ResponsiveLayout { layoutProperties in
                    HomepageView(layoutProperties: layoutProperties)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            timerWorkout.createTimerArray()
            timerWorkout.startTimer()
        }
    }
    
    func displayTime(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%01d:%02d", minutes, seconds)
    }
    
    func getTimerColor() -> Color {
        if timerWorkout.endOfSegment {
            if timerWorkout.timerSegments[timerWorkout.curr - 1].work {
                return dark
            } else {
                return dark.opacity(0.3)
            }
        } else if timerWorkout.timerSegments[timerWorkout.curr].work {
            return dark
        } else {
            return dark.opacity(0.3)
        }
    }
}

struct CueTimerWorkout_Previews: PreviewProvider {
    static var previews: some View {
        
        let entries = Entries()
    
        ResponsiveLayout { layoutProperties in
            CueTimerView(timerWorkout: TimerWorkout(cueWorkout: CueWorkout(cueEntries: entries.cueEntries, cuetimer: false), cuetimer: false, timerEntry: entries.timerEntry), cuetimer: false, layoutProperties: layoutProperties)
                .environmentObject(AuthManager())
                .environmentObject(ThemeManager())
                .environmentObject(entries)
        }
    }
}
