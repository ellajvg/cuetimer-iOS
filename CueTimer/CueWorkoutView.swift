//
//  CueWorkout.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-31.
//

import SwiftUI

struct CueWorkoutView: View {
    @EnvironmentObject var entries: Entries
    //@State private var curr: Int = 0
    //@State private var completed: Int = 1
    @State private var showExitAlert = false
    @State private var navigateToCueEntry = false
    @State private var navigateToHomepage = false
    
    let cuetimer: Bool
    let cueWorkout: CueWorkout
    let layoutProperties: LayoutProperties
    
    //var cues: [ExerciseCue] { entries.cues }
    //var total: Int { entries.cues.count }
    
    //var previousButtonDisabled: Bool {
    //    guard cueWorkoutModel.curr > 0 else {return true}
    //    return false
    //}
    //var endButtonDisabled: Bool {
    //    guard cueWorkoutModel.curr > cueWorkoutModel.total else //{return true}
   //     return false
    //}
    
    var body: some View {
        NavigationStack {
            VStack {
                if !cuetimer {
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(lineWidth: layoutProperties.customDimensValue.small)
                            .foregroundStyle(Color(red: 196/255, green: 217/255, blue: 220/255))
                        Circle()
                            .trim(from: 0.0, to: CGFloat(cueWorkout.curr) / CGFloat(cueWorkout.total))
                            .stroke(Color.accentColor, style: StrokeStyle(
                            lineWidth: layoutProperties.customDimensValue.small,
                            lineCap: .round,
                            lineJoin: .miter
                            ))
                            .rotationEffect(.degrees(-90))
                       
                        Text("\(cueWorkout.completed)/\(cueWorkout.total)")
                                .monospacedDigit()
                                .font(.system(size: layoutProperties.customFontSize.giant))
                                .foregroundStyle(Color.accentColor)
                                .bold()
                                .contentTransition(.numericText())
                            
                    }
                    .padding(.horizontal, layoutProperties.customDimensValue.smallMedium)
                    .animation(.linear, value: cueWorkout.completed)
                }
                VStack(spacing: 15) {
                    if cueWorkout.curr < cueWorkout.total {
                        VStack {
                            Spacer()
                            Text(cueWorkout.cues[cueWorkout.curr].exercise)
                                .font(.system(size: layoutProperties.customFontSize.medium))
                                .multilineTextAlignment(.center)
                            Spacer()
                            HStack {
                                Text(cueWorkout.cues[cueWorkout.curr].set)
                                Spacer()
                                if cueWorkout.cues[cueWorkout.curr].side != nil {
                                    Text(cueWorkout.cues[cueWorkout.curr].side!)
                                    Spacer()
                                }
                                
                                Text(cueWorkout.cues[cueWorkout.curr].reps)
                            }
                            .font(.system(size: layoutProperties.customFontSize.small))
                            
                        }
                        .padding(5)
                        .frame(height: 110)
                        .boxStyle(foregroundStyle: .white, background: .accentColor, shadowColor: .white)
                    } else {
                        VStack {
                            Text("Workout complete!")
                                .font(.system(size: layoutProperties.customFontSize.medium))
                        }
                        .padding(5)
                        .frame(height: 110)
                        .boxStyle(foregroundStyle: .white, background: .accentColor, shadowColor: .white)
                    }
                    VStack {
                        Text(cueWorkout.findNextExercise())
                            .font(.system(size: layoutProperties.customFontSize.small))
                    }
                    .boxStyle(
                        foregroundStyle: .black,
                        background: Color(red: 196/255, green: 217/255, blue: 220/255),
                        shadowColor: .white
                    )
                }
                .padding(.horizontal, 20)
                if !cuetimer {
                    Spacer()
                    HStack {
                        Button {
                            cueWorkout.goToPreviousExercise()
                        } label: {
                            Image(systemName: "arrowshape.backward.fill")
                        }
                        .foregroundStyle(cueWorkout.previousButtonDisabled ? Color(red: 196/255, green: 217/255, blue: 220/255) : Color.accentColor)
                        .disabled(cueWorkout.previousButtonDisabled)
                        Spacer()
                        if (cueWorkout.curr + 1 < cueWorkout.total) {
                            Button {
                                cueWorkout.goToNextExercise()
                            } label : {
                                Image(systemName: "arrowshape.forward.fill")
                            }
                        } else {
                            Button {
                                cueWorkout.endWorkout()
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                            }
                            .foregroundStyle(cueWorkout.endButtonDisabled ? Color(red: 196/255, green: 217/255, blue: 220/255) : Color.accentColor)
                            .disabled(cueWorkout.endButtonDisabled)
                        }
                            
                        
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal, 21)
                    .font(.system(size: layoutProperties.customFontSize.large))
                }
            }
            .toolbar {
                if !cuetimer {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            if cueWorkout.curr < cueWorkout.total {
                                showExitAlert = true
                            } else {
                                navigateToHomepage = true
                            }
                        } label: {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: layoutProperties.customFontSize.mediumLarge))
                                .foregroundColor(Color.accentColor)
                        }.alert("Progress will be lost", isPresented: $showExitAlert) {
                            Button("No", role: .cancel) { }
                            Button("Yes") {
                                navigateToCueEntry = true
                            }
                        } message: {
                            Text("Do you still want to exit this workout?")
                        }
                        .navigationDestination(isPresented: $navigateToCueEntry) {
                            CueEntryView(cuetimer: false, layoutProperties: layoutProperties)
                        }
                        .navigationDestination(isPresented: $navigateToHomepage) {
                            HomepageView(animationCompleted: true, layoutProperties: layoutProperties)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(
            
        )
    }
}

struct ExerciseCue {
    var exercise: String
    var reps: String
    var set: String
    var side: String?
}

struct CueWorkout_Previews: PreviewProvider {
    static var previews: some View {
        
        let entries = Entries()
    
        ResponsiveView { layoutProperties in
            CueWorkoutView(cuetimer: false, cueWorkout: CueWorkout(cueEntries: entries.cueEntries), layoutProperties: layoutProperties).environmentObject(entries)
        }
    }
}




 
