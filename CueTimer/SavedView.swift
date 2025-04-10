//
//  SavedView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-26.
//

import SwiftUI

struct SavedView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
        VStack {
            Text("Workouts")
                .font(.title)
                .fontWeight(.semibold)
            
            HStack {
                Button {
                    if let userId = authManager.getUserId() {
                        dataManager.fetchWorkouts(userId: userId, order: dataManager.selectedOrder)
                    }
                } label: {
                    HStack {
                        Text("Refresh")
                        Image(systemName: "arrow.clockwise")
                    }
                    .foregroundStyle(themeManager.theme.darkColor)
                }
                Spacer()
                Menu {
                    Picker("Sort by", selection: $dataManager.selectedOrder) {
                        Text("Completed").tag("completed")
                        Text("Updated").tag("updated")
                        Text("Added").tag("added")
                    }
                    .onChange(of: dataManager.selectedOrder) { oldOrder, newOrder in
                        if let userId = authManager.getUserId() {
                            dataManager.setOrderPreference(userId: userId, order: newOrder)
                        }
                    }
                } label: {
                    HStack {
                        Text("Reorder")
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .foregroundStyle(themeManager.theme.darkColor)
                }
            }
            .padding(.bottom, 5)
            
            if dataManager.workouts.count == 0 {
                Text("You have no saved workouts")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.theme.lightColor)
                    .cornerRadius(10)
                    .padding(.top, 4)
                    .padding(.bottom, 6)
            }

            List {
                ForEach(dataManager.workouts, id: \.name) { workout in
                    VStack {
                        HStack {
                            Text(workout.name)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Text(workout.type)
                                .font(.footnote)
                                .foregroundStyle(.white)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 5)
                                .background(themeManager.theme.darkColor)
                                .cornerRadius(5)
                                .padding(.trailing, 10)
                            
                            Spacer()
                            
                            HStack(spacing: 10) {
                                Button {
                                    workoutManager.name = workout.name
                                    
                                    if workout.type == "Cues" || workout.type == "CueTimer"{
                                        workoutManager.cueEntries = workout.exercises!
                                    }
                                    if workout.type == "Timer" || workout.type == "CueTimer"{
                                        workoutManager.timerEntry = workout.timer!
                                    }
                                    
                                    authManager.showAccountPopover = false
                                    
                                    if workout.type == "CueTimer" {
                                        workoutManager.cuetimer = true
                                        workoutManager.goToCueTimerEntry = true
                                    } else if workout.type == "Cues" {
                                        workoutManager.goToCueEntry = true
                                    } else if workout.type == "Timer" {
                                        workoutManager.goToTimerEntry = true
                                    }
                                } label: {
                                    Image(systemName: "pencil.line")
                                        .padding(.vertical, 5)
                                        .foregroundStyle(.black)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                Divider()
                                    
                                Button {
                                    workoutManager.name = workout.name
                                    
                                    if workout.type == "CueTimer" {
                                        workoutManager.cuetimer = true
                                        workoutManager.cueEntries = workout.exercises!
                                        workoutManager.createExerciseArray()
                                        workoutManager.timerEntry = workout.timer!
                                        workoutManager.createTimerArray()
                                    } else if workout.type == "Cues" {
                                        workoutManager.cueEntries = workout.exercises!
                                        workoutManager.createExerciseArray()
                                    } else if workout.type == "Timer" {
                                        workoutManager.timerEntry = workout.timer!
                                        workoutManager.createTimerArray()
                                    }
                                    
                                    authManager.showAccountPopover = false
                                    
                                    if workout.type == "CueTimer" || workout.type == "Timer" {
                                        workoutManager.goToCueTimerWorkout = true
                                    } else if workout.type == "Cues" {
                                        workoutManager.goToCueWorkout = true
                                    }
                                    
                                } label: {
                                    Text("Start")
                                        .padding(.vertical, 5)
                                        .foregroundStyle(.black)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .padding(.horizontal, 10)
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(color: themeManager.theme.shadowColor, radius: 2, y: 2)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            if let userId = authManager.getUserId() {
                                dataManager.deleteWorkout(userId: userId, name: workout.name)
                            }
                        } label: {
                            Image(systemName: "trash")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(themeManager.theme.darkColor, .white)
                        }
                        .tint(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.theme.lightColor)
                .cornerRadius(10)
                .padding(.top, 4)
                .padding(.bottom, 6)
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            if let userId = authManager.getUserId() {
                dataManager.fetchWorkouts(userId: userId, order: dataManager.selectedOrder)
            }
        }
        .padding(.horizontal)
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}

