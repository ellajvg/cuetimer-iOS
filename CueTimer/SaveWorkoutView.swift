//
//  SaveWorkoutView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-27.
//

import SwiftUI

struct SaveWorkoutView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var workoutName: String = ""
    @State private var saveAsNew: Bool = false
    @Binding var showSavePopover: Bool
    @Binding var goToNextStep: Bool
    @Binding var modified: Bool
    
    let existingWorkout: Bool
    let type: Int
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    showSavePopover = false
                    workoutName = ""
                    dataManager.saveErrorText = ""
                    dataManager.showSaveError = false
                } label: {
                    Image(systemName: "x.circle.fill")
                        .font(.title)
                        .foregroundStyle(themeManager.theme.darkColor)
                        .padding(.top)
                        .padding(.horizontal)
                }
            }
            
            VStack(spacing: 20) {
                VStack {
                    Text("Save workout")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    
                    if !saveAsNew && existingWorkout {
                        Text("To save your changes, click save. To save as a new workout, click save as new.")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .fixedSize(horizontal: false, vertical: true) 
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                    }
                    
                    if saveAsNew || !existingWorkout {
                        Text("Name it to save it!")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, -5)
                            .padding(.horizontal, 20)
                        
                        TextField("", text: $workoutName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: workoutName) { oldValue, newValue in
                                if oldValue != newValue {
                                    dataManager.saveErrorText = ""
                                    dataManager.showSaveError = false
                                }
                            }
                            .padding(.bottom, existingWorkout ? 10 : 20)
                            .padding(.horizontal, 20)
                    }
                    
                    if dataManager.showSaveError {
                        Text(dataManager.saveErrorText)
                            .font(.callout)
                            .foregroundStyle(themeManager.theme.darkColor)
                            .padding(.top, -15)
                            .padding(.bottom, 20)
                            .padding(.horizontal, 20)
                            .multilineTextAlignment(.center)
                    }
                    
                    if existingWorkout {
                        HStack {
                            Button {
                                withTransaction(Transaction(animation: nil)) {
                                    saveAsNew = false
                                }
                            } label: {
                                HStack {
                                    Text("Save changes")
                                    Image(systemName: "pencil")
                                }
                                .foregroundStyle(saveAsNew ? .gray : .black)
                                .disabled(!saveAsNew)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(saveAsNew ? .gray.opacity(0.2) : .white)
                            }
                            
                            Button {
                                withTransaction(Transaction(animation: nil)) {
                                    saveAsNew = true
                                }
                            } label: {
                                HStack {
                                    Text("Save as new")
                                    Image(systemName: "plus")
                                }
                                .foregroundStyle(!saveAsNew ? .gray : .black)
                                .disabled(saveAsNew)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(!saveAsNew ? .gray.opacity(0.2) : .white)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 4, y: 4)
                HStack(spacing: 20) {
                    Button {
                        if type == 1 || type == 3 {
                            workoutManager.createExerciseArray()
                        }
                        if type == 2 || type == 3 {
                            workoutManager.createTimerArray()
                        }
                        showSavePopover = false
                        goToNextStep = true
                        workoutName = ""
                        dataManager.saveErrorText = ""
                        dataManager.showSaveError = false
                    } label: {
                        Text("Don't save")
                            .boxStyle(foregroundStyle: .black, background: .white, shadowColor: .gray)
                    }
                    .growingButton()
                    
                    Button {
                        if let userId = authManager.getUserId() {
                            dataManager.getDocumentId(userId: userId, name: workoutName) { docId in
                                if (saveAsNew || !existingWorkout) && workoutName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    dataManager.saveErrorText = "Please enter a name for your workout."
                                    dataManager.showSaveError = true
                                } else if docId != nil {
                                    dataManager.saveErrorText = "You're already using this name!"
                                    dataManager.showSaveError = true
                                } else {
                                    if type == 1 { //cues only
                                        dataManager.saveCueWorkout(userId: userId, name: (!saveAsNew && existingWorkout) ? workoutManager.name! : workoutName, exercises: workoutManager.cueEntries) { success in
                                            if success {
                                                workoutManager.createExerciseArray()
                                                modified = false
                                                showSavePopover = false
                                                goToNextStep = true
                                            } else {
                                                dataManager.saveErrorText = "Oops! There was an error saving your workout. Please try again. "
                                                dataManager.showSaveError = true
                                            }
                                        }
                                    } else if type == 2 { //timer only
                                        dataManager.saveTimerWorkout(userId: userId, name: (!saveAsNew && existingWorkout) ? workoutManager.name! : workoutName, timer: workoutManager.timerEntry) { success in
                                            if success {
                                                workoutManager.createTimerArray()
                                                modified = false
                                                showSavePopover = false
                                                goToNextStep = true
                                            } else {
                                                dataManager.saveErrorText = "Oops! There was an error saving your workout. Please try again. "
                                                dataManager.showSaveError = true
                                            }
                                        }
                                    } else { //cuetimer
                                        dataManager.saveCueTimerWorkout(userId: userId, name: (!saveAsNew && existingWorkout) ? workoutManager.name! : workoutName, exercises: workoutManager.cueEntries, timer: workoutManager.timerEntry) { success in
                                            if success {
                                                workoutManager.createExerciseArray()
                                                workoutManager.createTimerArray()
                                                modified = false
                                                showSavePopover = false
                                                goToNextStep = true
                                            } else {
                                                dataManager.saveErrorText = "Oops! There was an error saving your workout. Please try again. "
                                                dataManager.showSaveError = true
                                            }
                                        }
                                    }
                                    
                                    dataManager.fetchWorkouts(userId: userId, order: dataManager.selectedOrder)
                                }
                            }
                        }
                    } label: {
                        Text("Save")
                            .boxStyle(foregroundStyle: .white, background: themeManager.theme.darkColor, shadowColor: .gray)
                    }
                    .growingButton()
                }
            }
            .padding(.top, 5)
            .padding(.horizontal)
            .padding(.bottom)
            
            Spacer()
        }
    }
}


struct SaveWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        SaveWorkoutView(showSavePopover: .constant(true), goToNextStep: .constant(false), modified: .constant(false), existingWorkout: false, type: 1)
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}

