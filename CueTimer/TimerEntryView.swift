//
//  TimerEntry.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-27.
//

import SwiftUI

struct TimerEntryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) private var dismiss
    @State private var modified: Bool = false
    @State private var goToNextStep: Bool = false
    @State private var showTimerInfo: Bool = false
    @State private var showNamePopover: Bool = false
    @State private var showSavePopover: Bool = false
    @State private var showExitAlert: Bool = false
    
    let cuetimer: Bool
    let cuesModified: Bool
    
    private var dark: Color { showExitAlert ? Color(red: 80/256, green: 80/256, blue: 80/256) : themeManager.theme.darkColor }
    
    private var light: Color { showExitAlert ? Color(red: 232/256, green: 232/256, blue: 232/256) : themeManager.theme.lightColor }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            if (workoutManager.name == nil && (cuetimer || workoutManager.timerEntry.workPeriods.count > 1 || workoutManager.timerEntry.workPeriods[0] != 30 || workoutManager.timerEntry.roundRest != 0 || workoutManager.timerEntry.periodRest != 0 || workoutManager.timerEntry.repeats != 1)) || (workoutManager.name != nil && (cuesModified || modified)) {
                                showExitAlert = true
                            } else {
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "house.fill")
                                .font(.title)
                                .foregroundColor(dark)
                        }
                        Spacer()
                        Button {
                            showTimerInfo = true
                        } label: {
                            Image(systemName: "info.circle.fill")
                                .font(.title)
                                .foregroundColor(dark)
                        }
                    }
                    .padding(.horizontal)
                    
                    if workoutManager.name == nil {
                        Text("Timer")
                            .fontWeight(.semibold)
                            .font(.title)
                    } else {
                        HStack {
                            Spacer()
                            Text(workoutManager.name!)
                                .font(.title)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Button {
                               showNamePopover = true
                            } label: {
                                Image(systemName: "pencil.line")
                                    .font(.title2)
                                    .foregroundStyle(.black)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 70)
                    }
                    
                    VStack {
                        Text("Work")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .padding(.top, 5)
                            .padding(.horizontal, 5)
                        
                        WorkPeriodList(showExitAlert: $showExitAlert, workPeriods: $workoutManager.timerEntry.workPeriods)
                        
                        HStack(spacing: 10) {
                            let isDisabled = workoutManager.timerEntry.workPeriods.count <= 1
                            Spacer()
                            Button(role: .destructive) {
                                if workoutManager.timerEntry.workPeriods.count > 1 {
                                    withTransaction(Transaction(animation: nil)) {
                                        workoutManager.timerEntry.workPeriods.removeLast()
                                        modified = true
                                    }
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                            }
                            .disabled(isDisabled)
                            .foregroundStyle(isDisabled ? light : dark)
                            
                            Button {
                                withTransaction(Transaction(animation: nil)) {
                                    workoutManager.timerEntry.workPeriods.append(30)
                                    modified = true
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                        .foregroundStyle(dark)
                        .font(.title3)
                        
                        Text("Rest")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 5)
                        
                        if workoutManager.timerEntry.workPeriods.count > 1 {
                            HStack {
                                Text("Period rest")
                                Spacer()
                                Picker("", selection: $workoutManager.timerEntry.periodRest) {
                                    ForEach(Array(stride(from: 0, through: 300, by: 5)), id: \.self) { number in
                                        if number > 59 {
                                            Text("\(number / 60) min \(number % 60) sec").tag(number)
                                        } else {
                                            Text("\(number) sec").tag(number)
                                        }
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .tint(.black)
                                .onChange(of: workoutManager.timerEntry.periodRest) { oldValue, newValue in
                                    if workoutManager.name != nil && oldValue != newValue {
                                        modified = true
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                            .padding(.leading, 15)
                            .padding(.trailing, 5)
                            .background(light)
                            .cornerRadius(10)
                        }
                        
                        HStack {
                            Text("Round rest")
                            Spacer()
                            Picker("", selection: $workoutManager.timerEntry.roundRest) {
                                ForEach(Array(stride(from: 0, through: 300, by: 5)), id: \.self) { number in
                                    if number > 59 {
                                        Text("\(number / 60) min \(number % 60) sec").tag(number)
                                    } else {
                                        Text("\(number) sec").tag(number)
                                    }
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .tint(.black)
                            .onChange(of: workoutManager.timerEntry.roundRest) { oldValue, newValue in
                                if workoutManager.name != nil && oldValue != newValue {
                                    modified = true
                                }
                            }
                        }
                        .padding(.vertical, 5)
                        .padding(.leading, 15)
                        .padding(.trailing, 5)
                        .background(light)
                        .cornerRadius(10)
                        
                        if !cuetimer {
                            Text("Rounds")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.semibold)
                                .padding(.top, 25)
                                .padding(.horizontal, 5)
                            
                            HStack {
                                Text("Rounds")
                                Spacer()
                                Picker("", selection: $workoutManager.timerEntry.repeats) {
                                    ForEach(1...100, id: \.self) { number in
                                        Text("\(number)").tag(number)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .tint(.black)
                                .onChange(of: workoutManager.timerEntry.repeats) { oldValue, newValue in
                                    if workoutManager.name != nil && oldValue != newValue {
                                        modified = true
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                            .padding(.leading, 15)
                            .padding(.trailing, 5)
                            .background(light)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                    HStack(spacing: 20) {
                        if cuetimer {
                            NavigationLink(destination: CueEntryView(cuetimer: cuetimer)) {
                                Text("Edit cues")
                                    .boxStyle(
                                        foregroundStyle: .black,
                                        background: .white,
                                        shadowColor: .gray
                                    )
                            }
                            .growingButton()
                        }
                        
                        Button {
                            if workoutManager.name == nil || modified {
                                showSavePopover = true
                            } else {
                                workoutManager.createTimerArray()
                                goToNextStep = true
                            }
                        } label: {
                            Text("Start workout")
                                .boxStyle(
                                    foregroundStyle: .white,
                                    background: dark,
                                    shadowColor: .gray
                                )
                        }
                        .growingButton()
                    }
                    .padding()
                }
                .overlay(showExitAlert ? .gray.opacity(0.3) : .gray.opacity(0.0))
                .blur(radius: showExitAlert ? 0.6 : 0.0)
                
                if showExitAlert {
                    VStack(spacing: 0) {
                        Text("Changes will not be saved")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.top, 20)
                            .padding(.horizontal, 10)
                        
                        Text("Still want to exit this workout?")
                            .padding(.top, 5)
                            .padding(.bottom, 15)
                            .padding(.horizontal, 15)
                            .multilineTextAlignment(.center)
                        
                        Divider()
                            .frame(maxWidth: .infinity)
                            .frame(height: 0.3)
                        
                        VStack {
                            HStack(spacing: 0) {
                                Button("No") {
                                    showExitAlert = false
                                }
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                Divider()
                                    .frame(height: 40)
                                    .background(Color.gray.opacity(0.01))
                                Button("Yes") {
                                    showExitAlert = false
                                    dismiss()
                                }
                                .fontWeight(.regular)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                            }
                        }
                        .foregroundStyle(themeManager.theme.darkColor)
                        .font(.title3)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, y: 5)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 60)
                }
            }
            .popover(isPresented: $showTimerInfo) {
                TimerInfoView(showTimerInfo: $showTimerInfo, cuetimer: cuetimer)
            }
            .popover(isPresented: $showSavePopover) {
                SaveWorkoutView(showSavePopover: $showSavePopover, goToNextStep: $goToNextStep, modified: $modified, existingWorkout: ((workoutManager.name != nil) ? true : false), type: cuetimer ? 3 : 2)
                    .presentationDetents([.fraction(0.5)])
            }
            .popover(isPresented: $showNamePopover) {
                ChangeNameView(showNamePopover: $showNamePopover, goToNextStep: $goToNextStep)
                    .presentationDetents([.fraction(0.5)])
            }
            .navigationDestination(isPresented: $goToNextStep) {
                CueTimerView(cuetimer: cuetimer)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct WorkPeriodList: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var showExitAlert: Bool
    @Binding var workPeriods: [Int]
    
    private var dark: Color { showExitAlert ? Color(red: 80/256, green: 80/256, blue: 80/256) : themeManager.theme.darkColor }
    
    private var light: Color { showExitAlert ? Color(red: 232/256, green: 232/256, blue: 232/256) : themeManager.theme.lightColor }
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(workPeriods.indices, id: \.self) { index in
                    HStack {
                        Text("Period \(index + 1)")
                        Spacer()
                        Picker("", selection: $workPeriods[index]) {
                            ForEach(Array(stride(from: 5, through: 300, by: 5)), id: \.self) { number in
                                if number > 59 {
                                    Text("\(number / 60) min \(number % 60) sec").tag(number)
                                } else {
                                    Text("\(number) sec").tag(number)
                                }
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .tint(.black)
                    }
                    .id(index)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .background(light)
                .cornerRadius(10)
                .padding(.bottom, 10)
            }
            .frame(maxHeight: CGFloat(workPeriods.count * 55))
            .listStyle(PlainListStyle())
            .onChange(of: workPeriods.count) {
                withAnimation {
                    proxy.scrollTo(workPeriods.indices.last, anchor: .bottom)
                }
            }
        }
    }
}

struct TimerEntry {
    var workPeriods: [Int] = []
    var roundRest: Int = 0
    var periodRest: Int = 0
    var repeats: Int = 1
    
    func toDictionary() -> [String: Any] {
        return [
            "workPeriods": workPeriods,
            "roundRest": roundRest,
            "periodRest": periodRest,
            "repeats": repeats
        ]
    }
}

struct TimerEntry_Previews: PreviewProvider {
    static var previews: some View {
        TimerEntryView(cuetimer: false, cuesModified: false)
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}

