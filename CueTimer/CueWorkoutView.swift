//
//  CueWorkout.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-31.
//

import SwiftUI

struct CueWorkoutView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var showEditAlert: Bool = false
    @State private var showExitAlert: Bool = false
    @State private var navigateToCueEntry: Bool = false
    @State private var navigateToHomepage: Bool = false
    
    private var dark: Color { showEditAlert || showExitAlert ? Color(red: 80/256, green: 80/256, blue: 80/256) : themeManager.theme.darkColor }
    
    private var light: Color { showEditAlert || showExitAlert ? Color(red: 232/256, green: 232/256, blue: 232/256) : themeManager.theme.lightColor }
    
    let cuetimer: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            if workoutManager.cueCurr < workoutManager.total {
                                showExitAlert = true
                            } else {
                                workoutManager.totalReset()
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "house.fill")
                                .font(.title)
                                .foregroundColor(dark)
                        }
                        Spacer()
                        Button {
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
                            .trim(from: 0.0, to: CGFloat(workoutManager.cueCurr) / CGFloat(workoutManager.total))
                            .stroke(dark, style: StrokeStyle(
                                lineWidth: 30,
                                lineCap: .round,
                                lineJoin: .miter
                            ))
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(workoutManager.cueCurr)/\(workoutManager.total)")
                            .monospacedDigit()
                            .font(.system(size: 100))
                            .foregroundStyle(dark)
                            .bold()
                            .contentTransition(.numericText())
                    }
                    .padding(.horizontal, 40)
                    .animation(.linear, value: workoutManager.cueCurr)
                    
                    VStack(spacing: 15) {
                        if !workoutManager.cues.isEmpty && workoutManager.cueCurr < workoutManager.total {
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
                            .padding(5)
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
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                    HStack {
                        Button {
                            workoutManager.goToPreviousExercise()
                        } label: {
                            Image(systemName: "arrowshape.backward.fill")
                        }
                        .foregroundStyle(workoutManager.previousCueButtonDisabled ? light : dark)
                        .disabled(workoutManager.previousCueButtonDisabled)
                        Spacer()
                        Button {
                            workoutManager.goToNextExercise()
                        } label : {
                            Image(systemName: "arrowshape.forward.fill")
                        }
                        .foregroundStyle(workoutManager.endButtonDisabled ?  light : dark)
                        .disabled(workoutManager.endButtonDisabled)
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal, 21)
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
                                    navigateToCueEntry = true
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
            .navigationDestination(isPresented: $navigateToCueEntry) {
                CueEntryView(cuetimer: false)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CueWorkout_Previews: PreviewProvider {
    static var previews: some View {
        CueWorkoutView(cuetimer: false)
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}




 
