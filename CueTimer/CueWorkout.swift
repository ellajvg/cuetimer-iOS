//
//  CueObject.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-02-12.
//

//import SwiftUI
//
//class CueWorkout: ObservableObject {
//    @Published var curr = 0
//    var total: Int { cues.count }
//    
//    let cueEntries: [CueEntry]
//    let cuetimer: Bool
//    var cues: [ExerciseCue]
//    
//    init(cueEntries: [CueEntry], cuetimer: Bool) {
//        self.cueEntries = cueEntries
//        self.cuetimer = cuetimer
//        self.cues = []
//        self.cues = createExerciseArray()
//    }
//
//    func goToPreviousExercise() {
//        curr-=1
//    }
//    
//    func goToNextExercise() {
//        curr += 1
//    }
//    
//    func setCurr(newCurr: Int) {
//        curr = newCurr
//    }
//    
//    func findNextExercise() -> String {
//        if cuetimer && curr == 0 &&  curr + 1 < total {
//            return "First exercise: " + cues[curr+1].exercise
//        } else if curr + 1 < total {
//            return "Next exercise: " + cues[curr+1].exercise
//        } else if curr + 1 == total {
//            return "This is your last set!"
//        }
//        return "Go flex in the mirror :)"
//    }
//    
//    func createExerciseArray() -> [ExerciseCue] {
//        var exercises: [ExerciseCue] = []
//        
//        if cuetimer {
//            exercises.append(ExerciseCue(exercise: "Get ready!"))
//        }
//        
//        for entry in cueEntries {
//            var set = 1
//            while set <= entry.sets {
//                if (entry.rightLeft) {
//                    exercises.append(ExerciseCue(exercise: entry.exercise, reps: "Reps: \(entry.reps)", set: "Set: \(set)/\(entry.sets)", side: "Side: R"))
//                    exercises.append(ExerciseCue(exercise: entry.exercise, reps: "Reps: \(entry.reps)", set: "Set: \(set)/\(entry.sets)", side: "Side: L"))
//                } else {
//                    exercises.append(ExerciseCue(exercise: entry.exercise, reps: "Reps: \(entry.reps)", set: "Set: \(set)/\(entry.sets)"))
//                }
//                set += 1
//            }
//        }
//        
//        return exercises
//    }
//    
//    var previousButtonDisabled: Bool {
//        curr <= 0
//    }
//    
//    var endButtonDisabled: Bool {
//        curr >= total
//    }
//}
