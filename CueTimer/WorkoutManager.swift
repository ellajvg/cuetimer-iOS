//
//  Workout.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-04-09.
//

import SwiftUI

class WorkoutManager: ObservableObject {
    @Published var name: String?
    @Published var cuetimer: Bool = false
    @Published var goToCueTimerEntry: Bool = false
    @Published var goToCueEntry: Bool = false
    @Published var goToTimerEntry: Bool = false
    @Published var goToCueTimerWorkout: Bool = false
    @Published var goToCueWorkout: Bool = false
    
    //CUE WORKOUT
    @Published var cueEntries: [CueEntry] = []
    @Published var cueCurr = 0
    @Published var cues: [ExerciseCue] = []
    var total: Int { cues.count }
    
    //TIMER WORKOUT
    @Published var timerEntry: TimerEntry = TimerEntry(workPeriods: [30])
    @Published var timerSegments: [TimerSegment] = [TimerSegment(length: 5, work: false, index: 0)]
    @Published var timerCurr: Int = 0
    @Published var timeElapsed = 0
    @Published var endOfSegment: Bool = false
    @Published var isTimerRunning = false
    @Published var startLast: Bool = true
    @Published var timer: Timer? = nil
    @Published var progressValue: CGFloat = 0.0
    var length: Int { timerSegments[timerCurr].length }
    var remainingTime: Int { length-timeElapsed }
    var totalTimeElapsed: Int {
        let completedSegments = timerSegments.prefix(timerCurr).reduce(0) { $0 + $1.length }
        return completedSegments + timeElapsed
    }
    var totalTime: Int { timerSegments.reduce(0) { $0 + $1.length } }
    var totalRemainingTime: Int { totalTime-totalTimeElapsed }
    var progress: CGFloat { CGFloat(length-remainingTime) / CGFloat(length) }
   
    
    //CUE WORKOUT FUNCTIONS
    func goToPreviousExercise() {
        cueCurr-=1
    }
    
    func goToNextExercise() {
        cueCurr += 1
    }
    
    func setCueCurr(newCurr: Int) {
        cueCurr = newCurr
    }
    
    func findNextExercise() -> String {
        if cuetimer && cueCurr == 0 &&  cueCurr + 1 < total {
            return "First exercise: " + cues[cueCurr + 1].exercise
        } else if cueCurr + 1 < total {
            return "Next exercise: " + cues[cueCurr + 1].exercise
        } else if cueCurr + 1 == total {
            return "This is your last set!"
        }
        return "Go flex in the mirror :)"
    }
    
    func createExerciseArray() {
        var cueArray: [ExerciseCue] = []
        
        if cuetimer {
            cueArray.append(ExerciseCue(exercise: "Get ready!"))
        }
        
        for entry in cueEntries {
            var set = 1
            while set <= entry.sets {
                if (entry.rightLeft) {
                    cueArray.append(ExerciseCue(exercise: entry.exercise, reps: "Reps: \(entry.reps)", set: "Set: \(set)/\(entry.sets)", side: "Side: R"))
                    cueArray.append(ExerciseCue(exercise: entry.exercise, reps: "Reps: \(entry.reps)", set: "Set: \(set)/\(entry.sets)", side: "Side: L"))
                } else {
                    cueArray.append(ExerciseCue(exercise: entry.exercise, reps: "Reps: \(entry.reps)", set: "Set: \(set)/\(entry.sets)"))
                }
                set += 1
            }
        }
        
        cues = cueArray
    }
    
    var previousCueButtonDisabled: Bool {
        cueCurr <= 0
    }
    
    var endButtonDisabled: Bool {
        cueCurr >= total
    }
    
    //TIMER FUNCTIONS
    func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            DispatchQueue.main.async {
                if self.remainingTime > 1 {
                    self.timeElapsed += 1
                } else if self.remainingTime == 1 && !(self.timerCurr + 1 < self.timerSegments.count) {
                    self.timeElapsed += 1
                    self.setCueCurr(newCurr: self.total)
                } else {
                    if self.timerCurr + 1 < self.timerSegments.count {
                        self.endOfSegment = true
                    }
                    self.goToNextTimer()
                }
            }
        }
    }
    
    func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
    }
    
    func goToPreviousTimer() {
        stopTimer()
        if timerCurr == 0 {
            timeElapsed = 0
            startTimer()
        } else if totalRemainingTime == 0 {
            startLast = true
            timeElapsed = 0
            startTimer()
            if cuetimer {
                setCueCurr(newCurr: timerSegments[timerCurr].index)
            }
            startLast = false
        } else if timerCurr > 0 {
            timeElapsed = 0
            if !startLast {
                timerCurr -= 1
                startLast = true
            } else {
                startLast = false;
            }
            startTimer()
            if cuetimer {
                setCueCurr(newCurr: timerSegments[timerCurr].index)
            }
        }
    }
    
    func goToNextTimer() {
        stopTimer()
        if timerCurr + 1 == timerSegments.count {
            timeElapsed = length
            setCueCurr(newCurr: total)
        } else if timerCurr + 1 < timerSegments.count {
            timerCurr += 1
            timeElapsed = 0
            startTimer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                self.endOfSegment = false
            }    
            if cuetimer {
               setCueCurr(newCurr: timerSegments[timerCurr].index)
            }
        }
    }
    
    func createTimerArray() {
        let workPeriods = timerEntry.workPeriods
        let periodRest = timerEntry.periodRest
        let roundRest = timerEntry.roundRest
        let repeats = timerEntry.repeats
        
        var round = 0
        var workPeriodCounter = 1
        
        while cuetimer ? workPeriodCounter < total: round < repeats {
            var period = 0
            while period < workPeriods.count && (cuetimer ? workPeriodCounter < total: true) {
                timerSegments.append(TimerSegment(length: workPeriods[period], work: true, index: cuetimer ? workPeriodCounter : round + 1))
                workPeriodCounter += 1
                period += 1
                if periodRest > 0 && period < workPeriods.count && (cuetimer ? workPeriodCounter < total: true) {
                    timerSegments.append(TimerSegment(length: periodRest, work: false, index: cuetimer ? workPeriodCounter - 1 : round + 1))
                }
            }
            if cuetimer ? workPeriodCounter < total: round + 1 < repeats {
                if roundRest > 0 {
                    timerSegments.append(TimerSegment(length: roundRest, work: false, index: cuetimer ? workPeriodCounter - 1 : round + 1))
                } else if periodRest > 0 {
                    timerSegments.append(TimerSegment(length: periodRest, work: false, index: cuetimer ? workPeriodCounter - 1 : round + 1))
                }
            }
            period = 0
            round += 1
        }
    }
    
    var previousTimerButtonDisabled: Bool {
        timerCurr <= 0 && remainingTime == length
    }
    
    var nextButtonDisabled: Bool {
        timerCurr >= timerSegments.count - 1 && remainingTime == 0
    }
    
    var playButtonDisabled: Bool {
        remainingTime <= 0  || isTimerRunning
    }
    
    var pauseButtonDisabled: Bool {
        remainingTime <= 0 || !isTimerRunning
    }
    
    func partialReset() {
        timer?.invalidate()
        timer = nil
        cueCurr = 0
        cues = []
        timerCurr = 0
        timeElapsed = 0
        endOfSegment = false
        isTimerRunning = false
        startLast = true
        progressValue = 0.0
        timerSegments = [TimerSegment(length: 5, work: false, index: 0)]
    }
    
    func totalReset() {
        partialReset()
        name = nil
        cuetimer = false
        cueEntries = []
        timerEntry = TimerEntry(workPeriods: [30])
        goToCueTimerEntry = false
        goToCueEntry = false
        goToTimerEntry = false
        goToCueTimerWorkout = false
        goToCueWorkout = false
    }
}

struct ExerciseCue {
    var exercise: String
    var reps: String?
    var set: String?
    var side: String?
}

struct TimerSegment {
    var length: Int
    var work: Bool
    var index: Int
}

