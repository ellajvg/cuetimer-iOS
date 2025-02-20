//
//  CueTimerWorkout.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-31.
//

import SwiftUI

struct CueTimerView: View {
    @EnvironmentObject var entries: Entries
    @State private var showExitAlert = false
    @State private var navigateToTimerEntry = false
    
    let cuetimer: Bool
    let cueWorkout: CueWorkout
    let timerWorkout: TimerWorkout
    let layoutProperties: LayoutProperties
    
    var body: some View {
        NavigationStack {
            VStack {
                if !cuetimer {
                    if timerWorkout.curr == 0 {
                        Text("Your workout begins in...")
                            .font(.system(size: layoutProperties.customFontSize.large))
                            .foregroundStyle(Color.accentColor)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .frame(height: layoutProperties.customFontSize.extraLarge * 1.2)
                            .padding(.top, 60)
                            .padding(.bottom, 20)
                    } else if timerWorkout.totalRemainingTime == 0 {
                        Text("Workout complete!")
                            .font(.system(size: layoutProperties.customFontSize.large * 1.2))
                            .foregroundStyle(Color.accentColor)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .frame(height: layoutProperties.customFontSize.extraLarge * 1.2)
                            .padding(.top, 60)
                            .padding(.bottom, 20)
                    } else if timerWorkout.timerSegments[timerWorkout.curr].work {
                        Text("Work")
                            .font(.system(size: layoutProperties.customFontSize.extraLarge))
                            .foregroundStyle(Color.accentColor)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.top, 60)
                            .padding(.bottom, 20)
                    } else {
                        Text("Rest")
                            .font(.system(size: layoutProperties.customFontSize.extraLarge))
                            .foregroundStyle(Color(red: 176/255, green: 197/255, blue: 200/255))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.top, 60)
                            .padding(.bottom, 20)
                    }
                }
                if cuetimer {
                    Spacer()
                }
                ZStack {
                    Circle()
                        .stroke(lineWidth: layoutProperties.customDimensValue.small)
                        .foregroundStyle(Color(red: 196/255, green: 217/255, blue: 220/255))
                    Circle()
                        .trim(from: 0.0, to: timerWorkout.endOfSegment ? 1.0 : timerWorkout.progress)    
                        .stroke(timerWorkout.timerColor, style: StrokeStyle(
                        lineWidth: layoutProperties.customDimensValue.small,
                        lineCap: .round,
                        lineJoin: .miter
                        ))
                        .rotationEffect(.degrees(-90))
                        
                    VStack {
                        Text(displayTime(timerWorkout.remainingTime))
                            .monospacedDigit()
                            .font(.system(size: layoutProperties.customFontSize.giant))
                            .foregroundStyle(Color.accentColor)
                            .bold()
                            .contentTransition(.numericText())
                        Text(displayTime(timerWorkout.totalRemainingTime))
                            .monospacedDigit()
                            .font(.system(size: layoutProperties.customFontSize.mediumLarge))
                            .foregroundStyle(Color.accentColor)
                    }
                }
                .padding(.horizontal, layoutProperties.customDimensValue.smallMedium)
                .animation(.linear(duration: 1.0), value: timerWorkout.remainingTime)

                if cuetimer {
                    Spacer()
                    CueWorkoutView(cuetimer: true,cueWorkout:  CueWorkout(cueEntries: entries.cueEntries), layoutProperties: layoutProperties)
                        .padding(.vertical, 30)   
                }
                
                Spacer()
                HStack {
                    Button {
                        timerWorkout.goToPreviousTimer()
                    } label: {
                        Image(systemName: "arrowshape.backward.fill")
                    }
                    .foregroundStyle(timerWorkout.previousButtonDisabled ? Color(red: 196/255, green: 217/255, blue: 220/255) : Color.accentColor)
                    .disabled(timerWorkout.previousButtonDisabled)
                    Spacer()
                    HStack(spacing: 20) {
                        Button {
                            timerWorkout.startTimer()
                        } label: {
                            Image(systemName: "play.fill")
                        }
                        .foregroundStyle(timerWorkout.playButtonDisabled ? Color(red: 196/255, green: 217/255, blue: 220/255) : Color.accentColor)
                        .disabled(timerWorkout.playButtonDisabled)
                        Button {
                            timerWorkout.stopTimer()
                        } label: {
                            Image(systemName: "pause.fill")
                        }
                        .foregroundStyle(timerWorkout.pauseButtonDisabled ? Color(red: 196/255, green: 217/255, blue: 220/255) : Color.accentColor)
                        .disabled(timerWorkout.pauseButtonDisabled)
                    }
                    Spacer()
                    Button {
                        timerWorkout.goToNextTimer()
                    } label: {
                        Image(systemName: "arrowshape.forward.fill")
                    }
                    .foregroundStyle(timerWorkout.nextButtonDisabled ? Color(red: 196/255, green: 217/255, blue: 220/255) : Color.accentColor)
                    .disabled(timerWorkout.nextButtonDisabled)
                }
                .padding(.top, cuetimer ? 0 : 40)
                .padding(.horizontal, cuetimer ? 21 : 50)
                .padding(.bottom, 10)
                .font(.system(size: layoutProperties.customFontSize.large))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showExitAlert = true
                    } label: {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.system(size: layoutProperties.customFontSize.mediumLarge))
                            .foregroundColor(Color.accentColor)
                    }.alert("Progress will be lost", isPresented: $showExitAlert) {
                        Button("No", role: .cancel) { }
                        Button("Yes") {
                            navigateToTimerEntry = true
                        }
                    } message: {
                        Text("Do you still want to exit this workout?")
                    }
                    .navigationDestination(isPresented: $navigateToTimerEntry) {
                        ResponsiveView { layoutProperties in
                            TimerEntryView(cuetimer: false, layoutProperties: layoutProperties)
                        }
                        
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            timerWorkout.createTimerArray()
            timerWorkout.startTimer()
        }
    }
    
    func displayTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%01d:%02d", minutes, seconds)
    }
}

struct CueTimerWorkout_Previews: PreviewProvider {
    static var previews: some View {
        
        let entries = Entries()
    
        ResponsiveView { layoutProperties in
            CueTimerView(cuetimer: false, cueWorkout: CueWorkout(cueEntries: entries.cueEntries), timerWorkout: TimerWorkout(cuetimer: false, timerEntry: entries.timerEntry, cueWorkout: CueWorkout(cueEntries: entries.cueEntries)), layoutProperties: layoutProperties).environmentObject(entries)
        }
    }
}
