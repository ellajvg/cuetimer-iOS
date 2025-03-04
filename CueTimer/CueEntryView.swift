//
//  CueEntry.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-27.
//

import SwiftUI

struct CueEntryView: View {
    @EnvironmentObject var entries: Entries
    @FocusState private var showKeyboard: Bool
    @State private var newExercise = CueEntry()
    @State private var exerciseToDelete: IndexSet?
    
    @State private var showEmptyAlert = false
    @State private var showNonEmptyAlert = false
    @State private var showExitAlert = false
    @State private var navigateToNextStep = false
    @State private var navigateToHomepage = false
    
    private var dark: Color { showEmptyAlert || showNonEmptyAlert || showExitAlert ? Color(red: 110/256, green: 110/256, blue: 110/256) : Color.darkAccent
    }
    
    private var light: Color { showEmptyAlert || showNonEmptyAlert || showExitAlert ? Color(red: 210/256, green: 210/256, blue: 210/256) : Color.lightAccent
    }
    
    let cuetimer: Bool
    let layoutProperties: LayoutProperties
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Exercises")
                        .fontWeight(.bold)
                        .foregroundStyle(dark)
                        .padding(.top, 10)
                        .font(.system(size: layoutProperties.customFontSize.large))
                    
                    if entries.cueEntries.isEmpty {
                        Text("Added exercises will appear here!")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(light)
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
                                        Text("Reps: \(cue.reps)")
                                            .frame(width: layoutProperties.customDimensValue.medium, alignment: .leading)
                                        Spacer()
                                        Text("Sets: \(cue.sets)")
                                            .frame(width: layoutProperties.customDimensValue.medium, alignment: .leading)
                                        Spacer()
                                        Text(cue.rightLeft ? "R/L: Yes" : "R/L: No")
                                            .frame(width: layoutProperties.customDimensValue.medium, alignment: .leading)
                                        Spacer()
                                    }
                                    .id(index)
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.hidden)
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button {
                                            moveItemUp(from: index)
                                        } label: {
                                            Image(systemName: "arrow.up.circle")
                                                .symbolRenderingMode(.palette)
                                                .foregroundStyle(.white, dark)
                                                
                                        }
                                        .tint(.white)
                                        
                                        Button {
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
                            .font(.system(size: layoutProperties.customFontSize.small))
                            .background(light)
                            .cornerRadius(10)
                            .padding(.top, 4)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 6)
                        }
                        .listStyle(PlainListStyle())
                        .onChange(of: entries.cueEntries.count) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                withAnimation {
                                    proxy.scrollTo(entries.cueEntries.indices.last, anchor: .bottom)
                                }
                            }
                        }
                        .onChange(of: showKeyboard) {
                            if showKeyboard {
                                withAnimation {
                                    proxy.scrollTo(entries.cueEntries.indices.last, anchor: .bottom)
                                }
                            }
                        }
                    }

                    
                    VStack(spacing: 20) {
                        ExerciseRow(entry: $newExercise, showKeyboard: $showKeyboard, layoutProperties: layoutProperties)
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
                                    showKeyboard = false
                                }
                            }
                            .disabled(newExercise.exercise.isEmpty)
                            .font(.system(size: layoutProperties.customFontSize.small))
                            .boxStyle(
                                foregroundStyle: newExercise.exercise.isEmpty ? .gray : .black,
                                background: .white,
                                shadowColor: .gray
                            )
                            
                            VStack {
                                let buttonText: String = cuetimer ? "Edit timer" : "Start workout"
                                if entries.cueEntries.count == 0 {
                                    Button (buttonText) {
                                        showEmptyAlert = true
                                    }
                                } else if !newExercise.exercise.isEmpty {
                                    Button (buttonText) {
                                        showNonEmptyAlert = true
                                    }
                                } else if !cuetimer {
                                    NavigationLink("Start workout", destination: CueWorkoutView(cueWorkout: CueWorkout(cueEntries: entries.cueEntries, cuetimer: false), cuetimer: false, layoutProperties: layoutProperties))
                                } else {
                                    NavigationLink("Edit timer", destination: TimerEntryView(cuetimer: true, layoutProperties: layoutProperties))
                                }
                            }
                            .font(.system(size: layoutProperties.customFontSize.small))
                            .boxStyle(
                                foregroundStyle: .white,
                                background: dark,
                                shadowColor: .gray
                            )
                            .navigationDestination(isPresented: $navigateToNextStep) {
                                if !cuetimer {
                                    CueWorkoutView(cueWorkout: CueWorkout(cueEntries: entries.cueEntries, cuetimer: false), cuetimer: false, layoutProperties: layoutProperties)
                                } else {
                                    TimerEntryView(cuetimer: true, layoutProperties: layoutProperties)
                                }
                            }
                        }
                    }

                    .padding()
                }
                .overlay(showEmptyAlert || showNonEmptyAlert || showExitAlert ? .gray.opacity(0.3) : .gray.opacity(0.0))
                .blur(radius: showEmptyAlert || showNonEmptyAlert || showExitAlert ? 0.6 : 0.0)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            if entries.cueEntries.count != 0 {
                                showExitAlert = true
                            } else {
                                navigateToHomepage = true
                            }
                        } label: {
                            Image(systemName: "house.fill")
                                .font(.system(size: layoutProperties.customFontSize.mediumLarge))
                                .foregroundColor(dark)
                                .blur(radius: showEmptyAlert || showNonEmptyAlert || showExitAlert ? 1.0 : 0.0)
                        }
                        .navigationDestination(isPresented: $navigateToHomepage) {
                            HomepageView(animationCompleted: true, layoutProperties: layoutProperties)
                        }
                    }
                }
                
                if showEmptyAlert || showNonEmptyAlert || showExitAlert {
                    let alertTitle = showEmptyAlert ? "No exercises added" : showNonEmptyAlert ? "Unadded exercise" : "Entries will be lost"
                    let alertText = showEmptyAlert ? "Please add at least one exercise!" : showNonEmptyAlert ? "Would you like to proceed without it?" : "Would you like to save this workout?"
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
                        
                        Divider()
                            .frame(maxWidth: .infinity)
                            .frame(height: 0.3)
                            .background(Color.gray.opacity(0.1))
                       
                        VStack {
                            if !showEmptyAlert {
                                HStack(spacing: 0) {
                                    Button("No") {
                                        if showNonEmptyAlert {
                                            showNonEmptyAlert = false
                                        } else {
                                            showExitAlert = false
                                            navigateToHomepage = true
                                        }
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
                                            navigateToNextStep = true
                                        } else {
                                            showExitAlert = false
                                            navigateToHomepage = true
                                            //save workout
                                        }
                                    }
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
                        .foregroundStyle(Color.darkAccent)
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
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func moveItemUp(from index: Int) {
        if !(entries.cueEntries.count == 1 || index == 0) {
            entries.cueEntries.swapAt(index, index - 1)
        }
    }
    
    func moveItemDown(from index: Int) {
        if !(entries.cueEntries.count == 1 || index == entries.cueEntries.count - 1) {
            entries.cueEntries.swapAt(index, index + 1)
        }
    }
    
    private func deleteItem(at index: Int) {
        if entries.cueEntries.indices.contains(index) {
            withAnimation {
                entries.cueEntries.remove(at: index)
            }
        }
    }
}


struct ExerciseRow: View {
    @Binding var entry: CueEntry
    @FocusState.Binding var showKeyboard: Bool
    
    let layoutProperties: LayoutProperties
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Exercise")
                .font(.system(size: layoutProperties.customFontSize.small))
            
            TextField("", text: $entry.exercise)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity)
                .focused($showKeyboard)
                
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
            CueEntryView(cuetimer: true, layoutProperties: layoutProperties)
                .environmentObject(Entries())
        }
    }
}
