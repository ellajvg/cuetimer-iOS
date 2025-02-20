//
//  CueEntry.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-27.
//

import SwiftUI

struct CueEntryView: View {
    @EnvironmentObject var entries: Entries
    @State private var newExercise = CueEntry()
    @State private var exerciseToDelete: IndexSet?
    @State private var showEmptyExercisesAlert = false
    @State private var showUnaddedExerciseAlert = false
    @State private var navigateToCueWorkout = false
    
    let cuetimer: Bool
    let layoutProperties: LayoutProperties
    
    var body: some View {
        NavigationStack {
                VStack {
                    Text("Exercises")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentColor)
                    .padding(.top, 10)
                    .font(.system(size: layoutProperties.customFontSize.large))
                    
                    if entries.cueEntries.isEmpty {
                        Text("Added exercises will appear here!")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 196/255, green: 217/255, blue: 220/255))
                            .cornerRadius(10)
                            .padding(.top, 4)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .font(.system(size: layoutProperties.customFontSize.small))
                    }
                    ScrollViewReader { proxy in
                        List {
                            ForEach(entries.cueEntries.indices, id: \.self) { index in
                                let cue = entries.cueEntries[index]
                                HStack {
                                    Text(cue.exercise)
                                        .frame(width: layoutProperties.customDimensValue.mediumLarge, alignment: .leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Spacer()
                                    Text("Reps: " + "\(cue.reps)")
                                        .frame(width: layoutProperties.customDimensValue.medium, alignment: .leading)
                                    Spacer()
                                    Text("Sets: " + "\(cue.sets)")
                                        .frame(width: layoutProperties.customDimensValue.medium, alignment: .leading)
                                    Spacer()
                                    Text(cue.rightLeft ? "R/L: Yes" : "R/L: No")
                                        .frame(width: layoutProperties.customDimensValue.medium, alignment: .leading)
                                    Spacer()
                                    
                                }
                                .id(index)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        entries.cueEntries.remove(at: index)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(Color.accentColor)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .font(.system(size: layoutProperties.customFontSize.small))
                            .background(Color(red: 196/255, green: 217/255, blue: 220/255))
                            .cornerRadius(10)
                            .padding(.top, 4)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .padding(.bottom, 5)
                            
                        }
                        .listStyle(PlainListStyle())
                        .onChange(of: entries.cueEntries.count) {
                            withAnimation {
                                proxy.scrollTo(entries.cueEntries.indices.last, anchor: .bottom)
                            }
                        }
                    }
                
                    VStack(spacing: 20) {
                        ExerciseRow(entry: $newExercise, layoutProperties: layoutProperties)
                            .boxStyle(
                                foregroundStyle: .black,
                                background: .white,
                                shadowColor: .gray
                            )
                        
                        HStack(spacing: 20) {
                            Button("Add exercise") {
                                if !newExercise.exercise.isEmpty {
                                    entries.cueEntries.append(newExercise)
                                    newExercise = CueEntry()
                                }
                            }
                            .font(.system(size: layoutProperties.customFontSize.small))
                            .boxStyle(
                                foregroundStyle: .black,
                                background: .white,
                                shadowColor: .gray
                            )
                            
                            VStack {
                                let buttonText: String = cuetimer ? "Create timer" : "Start workout"
                                if entries.cueEntries.count == 0 {
                                    Button (buttonText) {
                                        showEmptyExercisesAlert = true
                                    }
                                    .alert("No exercises added", isPresented: $showEmptyExercisesAlert) {
                                            Button("OK", role: .cancel) { }
                                    } message: {
                                        Text("Please add at least one exercise!")
                                    }
                                } else if !newExercise.exercise.isEmpty {
                                    Button (buttonText) {
                                        showUnaddedExerciseAlert = true
                                    }
                                    .alert("Unadded exercise", isPresented: $showUnaddedExerciseAlert) {
                                        Button("No", role: .cancel) { }
                                        Button("Yes") {
                                            navigateToCueWorkout = true
                                        }
                                    } message: {
                                        Text("Would you like to proceed without it?")
                                    }
                                } else if !cuetimer {
                                    NavigationLink("Start workout", destination: CueWorkoutView(cuetimer: false, cueWorkout: CueWorkout(cueEntries: entries.cueEntries), layoutProperties: layoutProperties))
                                } else {
                                    NavigationLink("Create timer", destination: TimerEntryView(cuetimer: true, layoutProperties: layoutProperties))
                                }
                            }
                            .font(.system(size: layoutProperties.customFontSize.small))
                            .boxStyle(
                                foregroundStyle: .white,
                                background: Color.accentColor,
                                shadowColor: .gray
                            )
                            .navigationDestination(isPresented: $navigateToCueWorkout) {
                                if !cuetimer {
                                    CueWorkoutView(cuetimer: false, cueWorkout: CueWorkout(cueEntries: entries.cueEntries), layoutProperties: layoutProperties)
                                } else {
                                    TimerEntryView(cuetimer: true, layoutProperties: layoutProperties)
                                }
                                
                            }
                        }
                    }
                    .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: ResponsiveView { layoutProperties in
                            HomepageView(animationCompleted: true, layoutProperties: layoutProperties)
                        }) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: layoutProperties.customFontSize.mediumLarge))
                                .foregroundColor(Color.accentColor)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
    }
}


struct ExerciseRow: View {
    @Binding var entry: CueEntry
    let layoutProperties: LayoutProperties
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Exercise")
                .font(.system(size: layoutProperties.customFontSize.small))
            
            TextField("", text: $entry.exercise)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reps")
                    
                    Picker("", selection: $entry.reps) {
                        ForEach(1...50, id: \.self) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .tint(.black)
                    .frame(maxWidth: 65)
                    
                }
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sets")
                    
                    Picker("", selection: $entry.sets) {
                        ForEach(1...50, id: \.self) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .tint(.black)
                    .frame(maxWidth: 65)
                }
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("R/L?")

                    Toggle("", isOn: $entry.rightLeft)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                        .labelsHidden()
                        .frame(width: 65, alignment: .leading)
                }
            }
            .font(.system(size: layoutProperties.customFontSize.small))
        }
    }
}

struct CueEntry {
    var exercise: String = ""
    var reps: Int = 1
    var sets: Int = 1
    var rightLeft: Bool = false
}

struct CueEntry_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveView { layoutProperties in
            CueEntryView(cuetimer: false, layoutProperties: layoutProperties)
                .environmentObject(Entries())
        }
    }
}
