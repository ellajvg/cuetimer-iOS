//
//  TimerEntry.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-27.
//

import SwiftUI

struct TimerEntryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var entries: Entries
    
    let cuetimer: Bool
    let layoutProperties: LayoutProperties
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Timer")
                    .font(.system(size: layoutProperties.customFontSize.large))
                    .fontWeight(.semibold)
                    .padding(.top, 10)
                
                VStack {
                    Text("Work")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: layoutProperties.customFontSize.small))
                        .fontWeight(.semibold)
                        .padding(.top, 5)
                        .padding(.horizontal, 5)
                    
                    WorkPeriodList(workPeriods: $entries.timerEntry.workPeriods, layoutProperties: layoutProperties)
                    
                    HStack(spacing: 10) {
                        let isDisabled = entries.timerEntry.workPeriods.count <= 1
                        Spacer()
                        Button(role: .destructive) {
                            if entries.timerEntry.workPeriods.count > 1 {
                                withTransaction(Transaction(animation: nil)) {
                                    entries.timerEntry.workPeriods.removeLast()
                                }
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                        }
                        .disabled(isDisabled)
                        .foregroundStyle(isDisabled ? themeManager.theme.lightColor : themeManager.theme.darkColor)
                        
                        Button {
                            withTransaction(Transaction(animation: nil)) { entries.timerEntry.workPeriods.append(30)
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .foregroundStyle(themeManager.theme.darkColor)
                    .font(.system(size: layoutProperties.customFontSize.smallMedium))
                    
                    Text("Rest")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: layoutProperties.customFontSize.small))
                        .fontWeight(.semibold)
                        .padding(.horizontal, 5)
                
                    if entries.timerEntry.workPeriods.count > 1 {
                        HStack {
                            Text("Period rest")
                            Spacer()
                            Picker("", selection: $entries.timerEntry.periodRest) {
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
                        }
                        .font(.system(size: layoutProperties.customFontSize.small))
                        .padding(.vertical, 5)
                        .padding(.leading, 15)
                        .padding(.trailing, 5)
                        .background(themeManager.theme.lightColor)
                        .cornerRadius(10)
                    }
                    
                    HStack {
                        Text("Round rest")
                        Spacer()
                        Picker("", selection: $entries.timerEntry.roundRest) {
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
                    }
                    .font(.system(size: layoutProperties.customFontSize.small))
                    .padding(.vertical, 5)
                    .padding(.leading, 15)
                    .padding(.trailing, 5)
                    .background(themeManager.theme.lightColor)
                    .cornerRadius(10)
                    
                    if !cuetimer {
                        Text("Rounds")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: layoutProperties.customFontSize.small))
                            .fontWeight(.semibold)
                            .padding(.top, 25)
                            .padding(.horizontal, 5)
                        
                        HStack {
                            Text("Rounds")
                            Spacer()
                            Picker("", selection: $entries.timerEntry.repeats) {
                                ForEach(1...100, id: \.self) { number in
                                    Text("\(number)").tag(number)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .tint(.black)
                        }
                        .font(.system(size: layoutProperties.customFontSize.small))
                        .padding(.vertical, 5)
                        .padding(.leading, 15)
                        .padding(.trailing, 5)
                        .background(themeManager.theme.lightColor)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
                HStack(spacing: 20) {
                    if cuetimer {
                        NavigationLink(destination: CueEntryView(cuetimer: cuetimer, layoutProperties: layoutProperties)) {
                            Text("Edit cues")
                                .boxStyle(
                                    foregroundStyle: .black,
                                    background: .white,
                                    shadowColor: .gray
                                )
                                .font(.system(size: layoutProperties.customFontSize.small))
                        } 
                        .growingButton()
                    }
                  
                    NavigationLink(destination: CueTimerView(timerWorkout: TimerWorkout(cueWorkout: CueWorkout(cueEntries: entries.cueEntries, cuetimer: cuetimer), cuetimer: cuetimer, timerEntry: entries.timerEntry), cuetimer: cuetimer, layoutProperties: layoutProperties)) {
                        Text("Start workout")
                            .boxStyle(
                                foregroundStyle: .white,
                                background: themeManager.theme.darkColor,
                                shadowColor: .gray
                            )
                            .font(.system(size: layoutProperties.customFontSize.small))
                            
                    }
                    .growingButton()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: ResponsiveLayout { layoutProperties in
                        HomepageView(layoutProperties: layoutProperties)
                    }) {
                        Image(systemName: "house.fill")
                            .font(.system(size: layoutProperties.customFontSize.mediumLarge))
                            .foregroundColor(themeManager.theme.darkColor)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct WorkPeriodList: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var workPeriods: [Int]
    let layoutProperties: LayoutProperties
    
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
                    .font(.system(size: layoutProperties.customFontSize.small))
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .background(themeManager.theme.lightColor)
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
}

struct TimerEntry_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveLayout { layoutProperties in
            TimerEntryView(cuetimer: false, layoutProperties: layoutProperties)
                .environmentObject(AuthManager())
                .environmentObject(ThemeManager())
                .environmentObject(Entries())
        }
        
    }
}

