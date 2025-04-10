//
//  DataManager.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-11.
//

import SwiftUI
import FirebaseFirestore

class DataManager: ObservableObject {
    @Published var workouts: [WorkoutData] = []
    @Published var showSaveError: Bool = false
    @Published var saveErrorText: String = ""
    @Published var showFetchingError: Bool = false
    @Published var fetchingErrorText: String = ""
    @Published var selectedOrder: String = "completed"
    
    private var db = Firestore.firestore()
    
    func deleteWorkout(userId: String, name: String) {
        self.getDocumentId(userId: userId, name: name) { docId in
            if let docId = docId {
                self.db.collection("users").document(userId).collection("workouts").document(docId).delete()
            }
        }
    }
    
    func saveCueWorkout(userId: String, name: String, exercises: [CueEntry], completion: @escaping (Bool) -> Void) {
        let exerciseData = exercises.map { $0.toDictionary() }
        
        self.getDocumentId(userId: userId, name: name) { docId in
            let workoutRef: DocumentReference
            var data: [String: Any] = [
                "name": name,
                "updated": Timestamp(),
                "exercises": exerciseData
            ]
            
            if let docId = docId {
                workoutRef = self.db.collection("users").document(userId).collection("workouts").document(docId)
            } else {
                workoutRef = self.db.collection("users").document(userId).collection("workouts").document()
                data["added"] = Timestamp()
                data["completed"] = Timestamp()
            }
            
            workoutRef.setData(data, merge: true) { error in
                if let error = error {
                    self.saveErrorText = "Error: \(error.localizedDescription)"
                    self.showSaveError = true
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    func saveTimerWorkout(userId: String, name: String, timer: TimerEntry, completion: @escaping (Bool) -> Void) {
        let timerData = timer.toDictionary()
        
        self.getDocumentId(userId: userId, name: name) { docId in
            let workoutRef: DocumentReference
            
            var data: [String: Any] = [
                "name": name,
                "updated": Timestamp(),
                "timer": timerData
            ]
            
            if let docId = docId {
                workoutRef = self.db.collection("users").document(userId).collection("workouts").document(docId)
            } else {
                workoutRef = self.db.collection("users").document(userId).collection("workouts").document()
                data["added"] = Timestamp()
                data["completed"] = Timestamp()
            }
            
            workoutRef.setData(data, merge: true) { error in
                if let error = error {
                    self.saveErrorText = "Error: \(error.localizedDescription)"
                    self.showSaveError = true
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    func saveCueTimerWorkout(userId: String, name: String, exercises: [CueEntry], timer: TimerEntry, completion: @escaping (Bool) -> Void) {
        self.saveCueWorkout(userId: userId, name: name, exercises: exercises) { success in
            if success {
                self.saveTimerWorkout(userId: userId, name: name, timer: timer) { success in
                    if success {
                        completion(true)
                        return
                    } else {
                        completion(false)
                        return
                    }
                }
            } else {
                completion(false)
                return
            }
        }
    }
    
    func fetchWorkouts(userId: String, order: String) {
        self.db.collection("users").document(userId).collection("workouts")
            .order(by: order, descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    self.fetchingErrorText = "Error: \(error.localizedDescription)"
                    self.showFetchingError = false
                    return
                }
                
                if let documents = snapshot?.documents {
                    DispatchQueue.main.async {
                        self.workouts = documents.compactMap { doc -> WorkoutData? in
                            let data = doc.data()
                            let name = data["name"]
                            var type: String = ""
                            var exercises: [CueEntry]? = nil
                            var timer: TimerEntry? = nil
                            
                            if data["exercises"] != nil && data["timer"] != nil {
                                type = "CueTimer"
                            } else if data["exercises"] != nil {
                                type = "Cues"
                            } else if data["timer"] != nil {
                                type = "Timer"
                            }
                            
                            if let exerciseDataDict = data["exercises"] as? [[String: Any]] {
                                exercises = exerciseDataDict.compactMap { exerciseData -> CueEntry? in
                                    return self.getCueEntry(exerciseData: exerciseData)
                                }
                            }
                            
                            if let timerData = data["timer"] as? [String: Any] {
                                timer = self.getTimerEntry(timerData: timerData)
                            }
                            
                            return WorkoutData(name: name as! String, type: type, exercises: exercises, timer: timer)
                        }
                    }
                }
            }
    }
    
    func getCueEntry(exerciseData: [String: Any]) -> CueEntry? {
        guard let exercise = exerciseData["exercise"] as? String,
              let reps = exerciseData["reps"] as? Int,
              let sets = exerciseData["sets"] as? Int,
              let rightLeft = exerciseData["rightLeft"] as? Bool else {
            return nil
        }
        return CueEntry(exercise: exercise, reps: reps, sets: sets, rightLeft: rightLeft)
    }
    
    func getTimerEntry(timerData: [String: Any]) -> TimerEntry? {
        guard let workPeriods = timerData["workPeriods"] as? [Int],
              let periodRest = timerData["periodRest"] as? Int,
              let roundRest = timerData["roundRest"] as? Int,
              let repeats = timerData["repeats"] as? Int else {
            return nil
        }
        return TimerEntry(workPeriods: workPeriods, roundRest: roundRest, periodRest: periodRest, repeats: repeats)
    }
    
    func changeWorkoutName(userId: String, oldName: String, newName: String, completion: @escaping (Bool) -> Void) {
        self.getDocumentId(userId: userId, name: oldName) { docId in
            if let docId = docId {
                self.db.collection("users").document(userId).collection("workouts").document(docId).setData(["name": newName], merge: true)
                completion(true)
                return
            } else {
                completion(false)
                return
            }
        }
    }
    
    func setOrderPreference(userId: String, order: String) {
        self.db.collection("users").document(userId).setData(["order": order], merge: true)
        self.fetchWorkouts(userId: userId, order: order)
    }
    
    func getOrderPreference(userId: String, orderPref: @escaping (String) -> Void) {
        let userDocRef = self.db.collection("users").document(userId)
        
        userDocRef.getDocument { document, error in
            if error != nil {
                orderPref("completed")
                self.selectedOrder = "completed"
                return
            }
            
            if let document = document, document.exists, let order = document.data()?["order"] as? String {
                orderPref(order)
                return
            } else {
                orderPref("completed")
                self.selectedOrder = "completed"
                return
            }
        }
    }
    
    func updateLastCompleted(userId: String, name: String) {
        print("completed update")
        self.getDocumentId(userId: userId, name: name) { docId in
            if let docId = docId {
                self.db.collection("users").document(userId).collection("workouts").document(docId).setData(["completed": Timestamp()], merge: true)
            }
        }
    }
    
    func getDocumentId(userId: String, name: String, docId: @escaping (String?) -> Void) {
        let workoutsRef = db.collection("users").document(userId).collection("workouts")
        
        workoutsRef.whereField("name", isEqualTo: name).getDocuments { snapshot, error in
            if error != nil {
                docId(nil)
                return
            }
            
            guard let documents = snapshot?.documents, let document = documents.first else {
                docId(nil)
                return
            }
            
            docId(document.documentID)
        }
    }
}

struct WorkoutData {
    var name: String
    var type: String
    var exercises: [CueEntry]?
    var timer: TimerEntry?
}

