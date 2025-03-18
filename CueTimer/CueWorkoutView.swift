//
//  CueWorkout.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-31.
//

import SwiftUI

struct CueWorkoutView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var entries: Entries
    @ObservedObject var cueWorkout: CueWorkout
    
    @State private var showEditAlert: Bool = false
    @State private var showExitAlert: Bool = false
    @State private var navigateToCueEntry: Bool = false
    @State private var navigateToHomepage: Bool = false
    
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
                            .trim(from: 0.0, to: CGFloat(cueWorkout.curr) / CGFloat(cueWorkout.total))
                            .stroke(dark, style: StrokeStyle(
                                lineWidth: layoutProperties.customDimensValue.small,
                                lineCap: .round,
                                lineJoin: .miter
                            ))
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(cueWorkout.curr)/\(cueWorkout.total)")
                            .monospacedDigit()
                            .font(.system(size: layoutProperties.customFontSize.giant))
                            .foregroundStyle(dark)
                            .bold()
                            .contentTransition(.numericText())
                    }
                    .padding(.horizontal, layoutProperties.customDimensValue.smallMedium)
                    .animation(.linear, value: cueWorkout.curr)
                    
                    VStack(spacing: 15) {
                        if cueWorkout.curr < cueWorkout.total {
                            VStack {
                                Spacer()
                                Text(cueWorkout.cues[cueWorkout.curr].exercise)
                                    .font(.system(size: layoutProperties.customFontSize.medium))
                                    .multilineTextAlignment(.center)
                                Spacer()
                                HStack {
                                    Text(cueWorkout.cues[cueWorkout.curr].set!)
                                    Spacer()
                                    if cueWorkout.cues[cueWorkout.curr].side != nil {
                                        Text(cueWorkout.cues[cueWorkout.curr].side!)
                                        Spacer()
                                    }
                                    
                                    Text(cueWorkout.cues[cueWorkout.curr].reps!)
                                }
                                .font(.system(size: layoutProperties.customFontSize.small))
                                
                            }
                            .padding(5)
                            .frame(height: 110)
                            .boxStyle(foregroundStyle: .white, background: dark, shadowColor: .white)
                        } else {
                            VStack {
                                Text("Workout complete!")
                                    .font(.system(size: layoutProperties.customFontSize.medium))
                            }
                            .padding(5)
                            .frame(height: 110)
                            .boxStyle(foregroundStyle: .white, background: dark, shadowColor: .white)
                        }
                        VStack {
                            Text(cueWorkout.findNextExercise())
                                .font(.system(size: layoutProperties.customFontSize.small))
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
                            cueWorkout.goToPreviousExercise()
                        } label: {
                            Image(systemName: "arrowshape.backward.fill")
                        }
                        .foregroundStyle(cueWorkout.previousButtonDisabled ? light : dark)
                        .disabled(cueWorkout.previousButtonDisabled)
                        Spacer()
                        Button {
                            cueWorkout.goToNextExercise()
                        } label : {
                            Image(systemName: "arrowshape.forward.fill")
                        }
                        .foregroundStyle(cueWorkout.endButtonDisabled ?  light : dark)
                        .disabled(cueWorkout.endButtonDisabled)
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal, 21)
                    .font(.system(size: layoutProperties.customFontSize.large))
                }
                .overlay(showEditAlert || showExitAlert ? .gray.opacity(0.3) : .gray.opacity(0.0))
                .blur(radius: showEditAlert || showExitAlert ? 0.6 : 0.0)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            if cueWorkout.curr < cueWorkout.total {
                                showExitAlert = true
                            } else {
                                navigateToHomepage = true
                            }
                        } label: {
                            Image(systemName: "house.fill")
                                .font(.system(size: layoutProperties.customFontSize.mediumLarge))
                                .foregroundColor(dark)
                                .blur(radius: showEditAlert || showExitAlert ? 0.6 : 0.0)
                        }
                        .navigationDestination(isPresented: $navigateToHomepage) {
                            HomepageView(layoutProperties: layoutProperties)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showEditAlert = true
                        } label: {
                            Image(systemName: "pencil.line")
                                .font(.system(size: layoutProperties.customFontSize.mediumLarge))
                                .foregroundStyle(dark)
                                .blur(radius: showEditAlert || showExitAlert ? 1.0 : 0.0)
                        }
                        .navigationDestination(isPresented: $navigateToCueEntry) {
                            CueEntryView(cuetimer: false, layoutProperties: layoutProperties)
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
                                    navigateToCueEntry = true
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
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ExerciseCue {
    var exercise: String
    var reps: String?
    var set: String?
    var side: String?
}

struct CueWorkout_Previews: PreviewProvider {
    static var previews: some View {
        
        let entries = Entries()
    
        ResponsiveLayout { layoutProperties in
            CueWorkoutView(cueWorkout: CueWorkout(cueEntries: entries.cueEntries, cuetimer: false), cuetimer: false, layoutProperties: layoutProperties)
                .environmentObject(AuthManager())
                .environmentObject(ThemeManager())
                .environmentObject(entries)
        }
    }
}




 
