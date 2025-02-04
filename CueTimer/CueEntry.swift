//
//  CueEntry.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-27.
//

import SwiftUI

struct CueEntry: View {
    @EnvironmentObject var entries: Entries
    @State private var newExercise = ExerciseEntry()
    @State private var exerciseToDelete: IndexSet?
    @State private var showEmptyExercisesAlert = false
    @State private var showUnsubmittedExerciseAlert = false
    @State private var navigateToWorkout = false
    
    var cuetimer: Bool
    
    var body: some View {
        NavigationStack {
                VStack {
                    Text("Exercises")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentColor)
                    .padding(.top, 10)
                    .font(.largeTitle)
                    
                    if entries.exercises.isEmpty {
                        Text("Added exercises will appear here!")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 196/255, green: 217/255, blue: 220/255))
                            .cornerRadius(10)
                            .padding(.top, 4)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                    }
                    ScrollViewReader { proxy in
                        List {
                            ForEach(entries.exercises.indices, id: \.self) { index in
                                let exercise = entries.exercises[index]
                                HStack {
                                    Text(exercise.exercise)
                                        .frame(width: 90, alignment: .leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Spacer()
                                    Text("Reps: " + "\(exercise.reps)")
                                        .frame(width: 66, alignment: .leading)
                                    Spacer()
                                    Text("Sets: " + "\(exercise.sets)")
                                        .frame(width: 66, alignment: .leading)
                                    Spacer()
                                    Text(exercise.rightLeft ? "R/L: Yes" : "R/L: No")
                                        .frame(width: 66, alignment: .leading)
                                    Spacer()
                                    
                                }
                                .id(index)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        entries.exercises.remove(at: index)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(Color.accentColor)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 196/255, green: 217/255, blue: 220/255))
                            .cornerRadius(10)
                            .padding(.top, 4)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .padding(.bottom, 5)
                            
                        }
                        .listStyle(PlainListStyle())
                        .onChange(of: entries.exercises.count) {
                            withAnimation {
                                proxy.scrollTo(entries.exercises.indices.last, anchor: .bottom)
                            }
                        }
                    }
                
                    VStack(spacing: 20) {
                        ExerciseRow(entry: $newExercise)
                            .boxStyle(
                                foregroundStyle: .black,
                                background: .white,
                                shadowColor: .gray
                            )
                        
                        HStack(spacing: 20) {
                            Button("Add exercise") {
                                if !newExercise.exercise.isEmpty {
                                    entries.exercises.append(newExercise)
                                    newExercise = ExerciseEntry()
                                }
                            }
                            .boxStyle(
                                foregroundStyle: .black,
                                background: .white,
                                shadowColor: .gray
                            )
                            
                            if !cuetimer {
                                VStack {
                                    if entries.exercises.count == 0 {
                                        Button ("Start workout") {
                                            showEmptyExercisesAlert = true
                                        }
                                        .alert("No exercises added", isPresented: $showEmptyExercisesAlert) {
                                                Button("OK", role: .cancel) { }
                                            } message: {
                                                Text("Please add at least one exercise to your workout!")
                                            }
                                    } else if !newExercise.exercise.isEmpty {
                                        Button ("Start workout") {
                                            showUnsubmittedExerciseAlert = true
                                        }
                                        .alert("Unsubmitted exercise", isPresented: $showUnsubmittedExerciseAlert) {
                                            Button("No", role: .cancel) { }
                                            Button("Yes") {
                                                navigateToWorkout = true
                                            }
                                        } message: {
                                            Text("You have an unsubmitted exercise, would you like to proceed without it?")
                                        }
                                    } else {
                                        NavigationLink("Start workout", destination: CueWorkout())
                                    }
                                }
                                .boxStyle(
                                    foregroundStyle: .white,
                                    background: Color.accentColor,
                                    shadowColor: .gray
                                )
                                .navigationDestination(isPresented: $navigateToWorkout) {
                                    CueWorkout()
                                }
                            } else {
                                NavigationLink("Create timer", destination: TimerEntry(cuetimer: true))
                                    .boxStyle(
                                        foregroundStyle: .white,
                                        background: Color.accentColor,
                                        shadowColor: .gray
                                    )
                            }
                        }
                    }
                    .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: Homepage(animationCompleted: true)) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.title)
                                .foregroundColor(Color.accentColor)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "info.circle.fill")
                            .font(.title)
                            .foregroundColor(Color.accentColor)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
    }
}


struct ExerciseRow: View {
    @Binding var entry: ExerciseEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Exercise")
            
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
                    .frame(maxWidth: 60)
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
                    .frame(maxWidth: 60)
                }
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("R/L?")

                    Toggle("", isOn: $entry.rightLeft)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                        .labelsHidden()
                        .frame(width: 60, alignment: .leading)
                }
            }
        }
    }
}

struct ExerciseEntry {
    var exercise: String = ""
    var reps: Int = 1
    var sets: Int = 1
    var rightLeft: Bool = false
}

struct CueEntry_Previews: PreviewProvider {
    static var previews: some View {
        CueEntry(cuetimer: false).environmentObject(Entries())
    }
}
