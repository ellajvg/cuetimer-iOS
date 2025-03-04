//
//  EntriesObject.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-02-13.
//

import SwiftUI

class Entries: ObservableObject {
    @Published var cueEntries: [CueEntry] = []
    @Published var timerEntry: TimerEntry = TimerEntry(workPeriods: [30])
    
    func reset() {
        cueEntries = []
        timerEntry = TimerEntry(workPeriods: [30])
    }
}
