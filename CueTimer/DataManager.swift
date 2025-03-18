//
//  DataManager.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-11.
//

import SwiftUI
import FirebaseFirestore

class DataManager: ObservableObject {
    private var db = Firestore.firestore()
    
    func saveWorkout(userId: String, name: String, exercises: [CueEntry]) {
        
    }
    
    func saveWorkout(userId: String, name: String, timer: [TimerEntry]) {
        
    }
    
    func saveWorkout(userId: String, name: String, exercises: [CueEntry], timer: [TimerEntry]) {
        
    }
    
    func checkName(name: String) {
        
    }
    
    func fetchWorkouts() {
        
    }
    
    func fetchWorkout(name: String) {
        
    }
}

struct Workout {
    var name: String
    var timestamp: Date
    var exercises: [CueEntry]
}

