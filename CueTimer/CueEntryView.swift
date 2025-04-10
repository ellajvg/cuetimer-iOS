//
//  CueEntry.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-27.
//

import SwiftUI

struct CueEntryView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) private var dismiss
    @FocusState private var showKeyboard: Bool
    @State private var newExercise: CueEntry = CueEntry()
    @State private var workoutName: String = ""
    @State private var showSaveButton: Bool = false
    
    @State private var showEmptyAlert: Bool = false
    @State private var showNonEmptyAlert: Bool = false
    @State private var showExitAlert: Bool = false
    
    @State private var modified: Bool = false
    @State private var showNamePopover: Bool = false
    @State private var showSavePopover: Bool = false
    @State private var showNameError: Bool = false
    @State private var nameErrorText: String = ""
    
    @State private var showCueInfo: Bool = false
    @State private var goToNextStep: Bool = false
    @State private var goToHomepage: Bool = false
    
    private var dark: Color { showEmptyAlert || showNonEmptyAlert || showExitAlert ? Color(red: 80/256, green: 80/256, blue: 80/256) : themeManager.theme.darkColor }
    
    private var light: Color { showEmptyAlert || showNonEmptyAlert || showExitAlert ? Color(red: 232/256, green: 232/256, blue: 232/256) : themeManager.theme.lightColor }
    
    let cuetimer: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            if (workoutManager.name == nil && workoutManager.cueEntries.count != 0) || (workoutManager.name != nil && modified) {
                                showExitAlert = true
                            } else {
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "house.fill")
                                .font(.title)
                                .foregroundColor(dark)
                        }
                        Spacer()
                        Button {
                            showCueInfo = true
                        } label: {
                            Image(systemName: "info.circle.fill")
                                .font(.title)
                                .foregroundColor(dark)
                        }
                    }
                    .padding(.horizontal)
                    
                    if workoutManager.name == nil {
                        Text("Exercises")
                            .fontWeight(.semibold)
                            .font(.title)
                    } else {
                        HStack {
                            Spacer()
                            Text(workoutManager.name!)
                                .font(.title)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Button {
                               showNamePopover = true
                            } label: {
                                Image(systemName: "pencil.line")
                                    .font(.title2)
                                    .foregroundStyle(.black)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 70)
                    }
                    
                    if workoutManager.cueEntries.isEmpty {
                        Text("Added exercises will appear here!")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(light)
                            .cornerRadius(10)
                            .padding(.top, 4)
                            .padding(.horizontal, 20)
                    }
                    
                    ScrollViewReader { proxy in
                        List {
                            ForEach(workoutManager.cueEntries.indices, id: \.self) { index in
                                let cue = workoutManager.cueEntries[index]
                                HStack {
                                    Text(cue.exercise)
                                        .frame(width: 90, alignment: .leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Spacer()
                                    Text("Reps: \(cue.reps > 0 ? "\(cue.reps)" : "X")")
                                        .frame(width: 66, alignment: .leading)
                                    Spacer()
                                    Text("Sets: \(cue.sets)")
                                        .frame(width: 66, alignment: .leading)
                                    Spacer()
                                    Text(cue.rightLeft ? "R/L: Yes" : "R/L: No")
                                        .frame(width: 66, alignment: .leading)
                                }
                                .id(index)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        modified = true
                                        moveItemUp(from: index)
                                    } label: {
                                        Image(systemName: "arrow.up.circle")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.white, dark)
                                        
                                    }
                                    .tint(.white)
                                    
                                    Button {
                                        modified = true
                                        moveItemDown(from: index)
                                    } label: {
                                        Image(systemName: "arrow.down.circle")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.white, dark)
                                    }
                                    .tint(.white)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        modified = true
                                        deleteItem(at: index)
                                    } label: {
                                        Image(systemName: "trash")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(dark, .white)
                                    }
                                    .tint(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(light)
                            .cornerRadius(10)
                            .padding(.top, 4)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 6)
                        }
                        .listStyle(PlainListStyle())
                        .onChange(of: workoutManager.cueEntries.count) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                withAnimation {
                                    proxy.scrollTo(workoutManager.cueEntries.indices.last, anchor: .bottom)
                                }
                            }
                        }
                        .onChange(of: showKeyboard) {
                            if showKeyboard {
                                withAnimation {
                                    proxy.scrollTo(workoutManager.cueEntries.indices.last, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    VStack(spacing: 20) {
                        ExerciseRow(showKeyboard: $showKeyboard, entry: $newExercise)
                            .boxStyle(
                                foregroundStyle: .black,
                                background: .white,
                                shadowColor: .gray
                            )
                        
                        HStack(spacing: 20) {
                            let buttonText: String = cuetimer ? "Edit timer" : "Start workout"
                            Button {
                                if !newExercise.exercise.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    workoutManager.cueEntries.append(newExercise)
                                    newExercise = CueEntry()
                                    showKeyboard = false
                                }
                                modified = true
                            } label: {
                                Text("Add exercise")
                                    .boxStyle(
                                        foregroundStyle: newExercise.exercise.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .black,
                                        background: .white,
                                        shadowColor: .gray
                                    )
                            }
                            .growingButton()
                            .disabled(newExercise.exercise.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            
                            Button {
                                if workoutManager.cueEntries.count == 0 {
                                    showEmptyAlert = true
                                } else if !newExercise.exercise.isEmpty {
                                    showNonEmptyAlert = true
                                } else if !cuetimer && (workoutManager.name == nil || modified) {
                                    showSavePopover = true
                                } else {
                                    workoutManager.createExerciseArray()
                                    goToNextStep = true
                                }
                            } label: {
                                Text(buttonText)
                                    .boxStyle(
                                        foregroundStyle: .white,
                                        background: dark,
                                        shadowColor: .gray
                                    )
                            }
                            .growingButton()
                        }
                    }
                    .padding()
                }
                .overlay(showEmptyAlert || showNonEmptyAlert || showExitAlert ? .gray.opacity(0.3) : .gray.opacity(0.0))
                .blur(radius: showEmptyAlert || showNonEmptyAlert || showExitAlert ? 0.6 : 0.0)
                
                if showEmptyAlert || showNonEmptyAlert || showExitAlert {
                    var alertTitle: String {
                        if showEmptyAlert {
                            return "No exercises added"
                        } else if showNonEmptyAlert {
                            return "Unadded exercise"
                        } else {
                            return "Changes will not be saved"
                        }
                    }
                    
                    var alertText: String {
                        if showEmptyAlert {
                            return "Please add at least one exercise!"
                        } else if showNonEmptyAlert {
                            return "Would you like to proceed without it?"
                        } else {
                            return "Still want to exit this workout?"
                        }
                    }
                    
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
                        
                        VStack {
                            if !showEmptyAlert {
                                HStack(spacing: 0) {
                                    Button("No") {
                                        showNonEmptyAlert = false
                                        showExitAlert = false
                                    }
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                    Divider()
                                        .frame(height: 40)
                                        .background(Color.gray.opacity(0.01))
                                    Button("Yes") {
                                        if showNonEmptyAlert {
                                            showNonEmptyAlert = false
                                            goToNextStep = true
                                        } else if showExitAlert {
                                            showExitAlert = false
                                            dismiss()
                                        }
                                    }
                                    .fontWeight(.regular)
                                    .frame(maxWidth: .infinity)
                                    .padding(10)
                                }
                            } else {
                                Button("Ok") {
                                    showEmptyAlert = false
                                }
                                .fontWeight(.semibold)
                                .padding(10)
                            }
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
            .popover(isPresented: $showCueInfo, content: {
                CueInfoView(showCueInfo: $showCueInfo, cuetimer: cuetimer)
            })
            .popover(isPresented: $showSavePopover) {
                SaveWorkoutView(showSavePopover: $showSavePopover, goToNextStep: $goToNextStep, modified: $modified, existingWorkout: (workoutManager.name != nil) ? true : false, type: 1)
                    .presentationDetents([.fraction(0.5)])
            }
            .popover(isPresented: $showNamePopover) {
                ChangeNameView(showNamePopover: $showNamePopover, goToNextStep: $goToNextStep)
                    .presentationDetents([.fraction(0.5)])
            }
            .navigationDestination(isPresented: $goToNextStep) {
                if !cuetimer {
                    CueWorkoutView(cuetimer: false)
                } else {
                    TimerEntryView(cuetimer: true, cuesModified: modified)
                }
            }
        }
        .onAppear {
            if workoutManager.name != nil {
                workoutName = workoutManager.name!
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func moveItemUp(from index: Int) {
        if !(workoutManager.cueEntries.count == 1 || index == 0) {
            workoutManager.cueEntries.swapAt(index, index - 1)
        }
    }

    private func moveItemDown(from index: Int) {
        if !(workoutManager.cueEntries.count == 1 || index == workoutManager.cueEntries.count - 1) {
            workoutManager.cueEntries.swapAt(index, index + 1)
        }
    }

    private func deleteItem(at index: Int) {
        if workoutManager.cueEntries.indices.contains(index) {
            withAnimation {
                workoutManager.cueEntries.remove(at: index)
            }
        }
    }
}

struct ExerciseRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    @FocusState.Binding var showKeyboard: Bool
    @Binding var entry: CueEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Exercise")
            
            TextField("", text: $entry.exercise)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity)
                .focused($showKeyboard)
            
            HStack {
                HStack(spacing: -5) {
                    Text("Reps")
                    
                    Picker("", selection: $entry.reps) {
                        Text("N/A").tag(0)
                        ForEach(1...50, id: \.self) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .tint(.black)
                }
                Spacer()
                HStack(spacing: -5) {
                    Text("Sets")
                    
                    Picker("", selection: $entry.sets) {
                        ForEach(1...50, id: \.self) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .tint(.black)
                }
                Spacer()
                HStack(spacing: -5) {
                    Text("R/L")
                    
                    Picker("", selection: $entry.rightLeft) {
                        Text("Yes").tag(true)
                        Text("No").tag(false)
                    }
                    .pickerStyle(MenuPickerStyle())
                    .tint(.black)
                }
            }
        }
    }
}

struct CueEntry {
    var exercise: String = ""
    var reps: Int = 10
    var sets: Int = 1
    var rightLeft: Bool = false
    
    func toDictionary() -> [String: Any] {
        return [
            "exercise": exercise,
            "reps": reps,
            "sets": sets,
            "rightLeft": rightLeft
        ]
    }
}

struct CueEntry_Previews: PreviewProvider {
    static var previews: some View {
        CueEntryView(cuetimer: false)
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}
