//
//  TimerWorkout.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-02-15.
//

import SwiftUI

@Observable
class TimerWorkout {
    let cuetimer: Bool
    let cueWorkout: CueWorkout
    let timerEntry: TimerEntry
    var timerSegments: [TimerSegment] = [TimerSegment(length: 5, work: false)]
    
    var curr: Int = 0
    var total: Int { cueWorkout.total }
    var length: Int { timerSegments[curr].length }
    var timerColor: Color { timerSegments[curr].work ? Color.accentColor : Color.accentColor.opacity(0.4) }
    
    init(cuetimer: Bool, timerEntry: TimerEntry, cueWorkout: CueWorkout) {
        self.cuetimer = cuetimer
        self.timerEntry = timerEntry
        self.cueWorkout = cueWorkout
    }
    
    var endOfSegment: Bool = false
    var startLast: Bool = true
    var timer: Timer? = nil
    var timeElapsed = 0
    var isTimerRunning = false
    var remainingTime: Int {
        length-timeElapsed
    }
    
    var totalTimeElapsed: Int {
        let completedSegments = timerSegments.prefix(curr).reduce(0) { $0 + $1.length }
        return completedSegments + timeElapsed
    }
    var totalTime: Int {
        timerSegments.reduce(0) { $0 + $1.length }
    }
    var totalRemainingTime: Int {
        totalTime-totalTimeElapsed
    }
    
    var progressValue: CGFloat = 0.0
    var progress: CGFloat {
        CGFloat(length-remainingTime) / CGFloat(length)
    }
    
    func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            if remainingTime > 1 {
                timeElapsed += 1
            } else if remainingTime == 1 && !(curr + 1 < timerSegments.count) {
                timeElapsed += 1
            } else {
                endOfSegment = true
                goToNextTimer()
            }
        }
    }
    
    func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
    }
    
    func goToPreviousTimer() {
        stopTimer()
        if curr - 1 >= 0 {
            timeElapsed = 0
            if !(curr == timerSegments.count - 1 && startLast) {
                curr -= 1
            } else {
                startLast = false;
            }
            startTimer()
            if cuetimer && timerSegments[curr].work {
                cueWorkout.goToPreviousExercise()
            }
        }
    }
    
    func goToNextTimer() {
        stopTimer()
        startLast = true
            
        if curr + 1 < timerSegments.count {
            endOfSegment = true
            curr += 1
            timeElapsed = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.endOfSegment = false
            }
            
            startTimer()
                    
            if cuetimer && timerSegments[curr].work {
                cueWorkout.goToNextExercise()
            }
        }
    }
    
    func createTimerArray() {
        let workPeriods = timerEntry.workPeriods
        let periodRest = timerEntry.periodRest
        let roundRest = timerEntry.roundRest
        let repeats = timerEntry.repeats
        
        var round = 0
        var workPeriodCounter = 0
        
        while cuetimer ? workPeriodCounter <= total : round < repeats {
            var period = 0
            while period < workPeriods.count && (cuetimer ? workPeriodCounter <= total : true) {
                timerSegments.append(TimerSegment(length: workPeriods[period], work: true))
                workPeriodCounter += 1
                if periodRest > 0 && (cuetimer ? workPeriodCounter < total : period+1 < workPeriods.count) {
                    timerSegments.append(TimerSegment(length: periodRest, work: false))
                }
                period += 1
            }
            if cuetimer ? workPeriodCounter < total : round+1 < repeats {
                if roundRest > 0 {
                    timerSegments.append(TimerSegment(length: roundRest, work: false))
                } else if periodRest > 0 {
                    timerSegments.append(TimerSegment(length: periodRest, work: false))
                }
            }
            period = 0
            print("round + \(round)")
            print("repeats + \(repeats)")
            round += 1
        }
        
        print(timerSegments)
    }
    
    var previousButtonDisabled: Bool {
        guard curr > 0 else {return true}
        return false
    }
    
    var nextButtonDisabled: Bool {
        guard curr < timerSegments.count - 1 else {return true}
        return false
    }
    
    var playButtonDisabled: Bool {
        guard remainingTime > 0, !isTimerRunning else {return true}
        return false
    }
    
    var pauseButtonDisabled: Bool {
        guard remainingTime > 0, isTimerRunning else {return true}
        return false
    }
}

struct TimerSegment {
    var length: Int
    var work: Bool
}
