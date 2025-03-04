//
//  TimerWorkout.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-02-15.
//

import SwiftUI

class TimerWorkout: ObservableObject {
    @ObservedObject var cueWorkout: CueWorkout
    let cuetimer: Bool
    let timerEntry: TimerEntry
    var timerSegments: [TimerSegment] = [TimerSegment(length: 5, work: false, index: 0)]
    
    var curr: Int = 0
    var total: Int { cueWorkout.total }
    var length: Int { timerSegments[curr].length }
    
    init(cueWorkout: CueWorkout, cuetimer: Bool, timerEntry: TimerEntry) {
        self.cueWorkout = cueWorkout
        self.cuetimer = cuetimer
        self.timerEntry = timerEntry
    }
    
    @Published var timeElapsed = 0
    @Published var endOfSegment: Bool = false
    @Published var isTimerRunning = false
    var startLast: Bool = true
    var timer: Timer? = nil
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
                cueWorkout.setCurr(newCurr: total)
            } else {
                if curr + 1 < timerSegments.count {
                    endOfSegment = true
                }
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
        if curr == 0 {
            timeElapsed = 0
            startTimer()
        } else if totalRemainingTime == 0 {
            startLast = true
            timeElapsed = 0
            startTimer()
            if cuetimer {
                cueWorkout.setCurr(newCurr: timerSegments[curr].index)
            }
            startLast = false
        } else if curr > 0 {
            timeElapsed = 0
            if !startLast {
                curr -= 1
                startLast = true
            } else {
                startLast = false;
            }
            startTimer()
            if cuetimer {
                cueWorkout.setCurr(newCurr: timerSegments[curr].index)
            }
        }
    }
    
    func goToNextTimer() {
        stopTimer()
        if curr + 1 == timerSegments.count {
            timeElapsed = length
            cueWorkout.setCurr(newCurr: total)
        } else if curr + 1 < timerSegments.count {
            curr += 1
            timeElapsed = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                self.endOfSegment = false
            }
            
            startTimer()
                    
            if cuetimer {
                cueWorkout.setCurr(newCurr: timerSegments[curr].index)
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
    
    var previousButtonDisabled: Bool {
        curr <= 0 && remainingTime == length
    }
    
    var nextButtonDisabled: Bool {
        curr >= timerSegments.count - 1 && remainingTime == 0
    }
    
    var playButtonDisabled: Bool {
        remainingTime <= 0  || isTimerRunning
    }
    
    var pauseButtonDisabled: Bool {
        remainingTime <= 0 || !isTimerRunning
    }
}

struct TimerSegment {
    var length: Int
    var work: Bool
    var index: Int
}
