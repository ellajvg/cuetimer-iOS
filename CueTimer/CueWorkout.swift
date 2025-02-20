//
//  CueObject.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-02-12.
//

import SwiftUI

@Observable
class CueWorkout {
    var curr = 0
    var completed = 1
    var total: Int { cues.count }
    
    let cueEntries: [CueEntry]
    var cues: [ExerciseCue]
    
    init(cueEntries: [CueEntry]) {
        self.cueEntries = cueEntries
        self.cues = []
        self.cues = createExerciseArray()
    }

    func goToPreviousExercise() {
        if (curr == total) {
            curr-=1
        } else if curr != 0 {
            if (cues[curr].side != nil && cues[curr].side == "R") {
                completed -= 1
            } else if cues[curr].side == nil {
                completed -= 1
            }
            curr -= 1
        }
    }
    
    func goToNextExercise() {
        if curr < total {
            if (cues[curr].side != nil && cues[curr].side == "L") {
                completed += 1
            } else if cues[curr].side == nil {
                completed += 1
            }
            curr += 1
        }
    }
    
    func endWorkout() {
        if curr < total {
            curr += 1
        }
    }
    
    func findNextExercise() -> String {
        if curr < total {
            if curr+1 < total {
                return "Next exercise: " + cues[curr].exercise
            } else {
                return "This is your last set!"
            }
        }
        return "Go flex in the mirror :)"
    }
    
    func createExerciseArray() -> [ExerciseCue] {
        var exercises: [ExerciseCue] = []
        
        for entry in cueEntries {
            var set = 1
            while set <= entry.sets {
                if (entry.rightLeft) {
                    exercises.append(ExerciseCue(exercise: entry.exercise, reps: "Reps: \(entry.reps)", set: "Set: \(set)/\(entry.sets)", side: "Side: R"))
                    exercises.append(ExerciseCue(exercise: entry.exercise, reps: "Reps: \(entry.reps)", set: "Set: \(set)/\(entry.sets)", side: "Side: L"))
                } else {
                    exercises.append(ExerciseCue(exercise: entry.exercise, reps: "Reps: \(entry.reps)", set: "Set: \(set)/\(entry.sets)"))
                }
                set += 1
            }
        }
        
        return exercises
    }
    
    var previousButtonDisabled: Bool {
        guard curr > 0 else {return true}
        return false
    }
    var endButtonDisabled: Bool {
        guard curr < total else {return true}
        return false
    }
}
