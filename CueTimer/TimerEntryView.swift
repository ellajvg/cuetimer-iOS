//
//  TimerEntry.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-27.
//

import SwiftUI

struct TimerEntryView: View {
    @EnvironmentObject var entries: Entries
    let cuetimer: Bool
    let layoutProperties: LayoutProperties
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("Work")
                        .font(.system(size: layoutProperties.customFontSize.smallMedium))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                        .padding(.top, 10)
                        
                    WorkPeriodList(workPeriods: $entries.timerEntry.workPeriods, layoutProperties: layoutProperties)
                    
                    HStack {
                        Spacer()
                        Button(role: .destructive) {
                            if entries.timerEntry.workPeriods.count > 1 {
                                entries.timerEntry.workPeriods.removeLast()
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: layoutProperties.customFontSize.small))
                        }
                        
                        Button {
                            entries.timerEntry.workPeriods.append(30)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: layoutProperties.customFontSize.small))
                        }
                    }
                    .foregroundStyle(Color.accentColor)
                    .font(.title3)
                    
                    Text("Rest")
                        .font(.system(size: layoutProperties.customFontSize.smallMedium))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                
                    HStack {
                        if entries.timerEntry.workPeriods.count > 1 {
                            Text("Rest in between periods")
                        } else {
                            Text("Rest")
                        }
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
                    .background(Color(red: 196/255, green: 217/255, blue: 220/255))
                    .cornerRadius(10)
                    
                    if entries.timerEntry.workPeriods.count > 1 {
                        HStack {
                            Text("Rest in between rounds")
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
                        .background(Color(red: 196/255, green: 217/255, blue: 220/255))
                        .cornerRadius(10)
                    }
                    
                    if !cuetimer {
                        Text("Repeats")
                            .font(.system(size: layoutProperties.customFontSize.smallMedium))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.accentColor)
                            .padding(.top, 20)
                        
                        HStack {
                            Text("Repeats")
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
                        .background(Color(red: 196/255, green: 217/255, blue: 220/255))
                        .cornerRadius(10)
                    }
                }
                .boxStyle(
                    foregroundStyle: .black,
                    background: .white,
                    shadowColor: .gray
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 15)
                .padding(.top, 25)
                Spacer()
                NavigationLink("Start workout", destination: CueTimerView(cuetimer: cuetimer, cueWorkout: CueWorkout(cueEntries: entries.cueEntries), timerWorkout: TimerWorkout(cuetimer: cuetimer, timerEntry: entries.timerEntry, cueWorkout: CueWorkout(cueEntries: entries.cueEntries)), layoutProperties: layoutProperties)).environmentObject(Entries())
                    .boxStyle(
                        foregroundStyle: .white,
                        background: Color.accentColor,
                        shadowColor: .gray
                    )
                    .font(.system(size: layoutProperties.customFontSize.small))
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !cuetimer {
                        NavigationLink(destination: ResponsiveView { layoutProperties in
                            HomepageView(animationCompleted: true, layoutProperties: layoutProperties)
                        }) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.title)
                                .foregroundColor(Color.accentColor)
                        }
                    } else {
                        NavigationLink(destination: ResponsiveView { layoutProperties in
                            CueEntryView(cuetimer: true, layoutProperties: layoutProperties)
                        }) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.title)
                                .foregroundColor(Color.accentColor)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct WorkPeriodList: View {
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
                .background(Color(red: 196/255, green: 217/255, blue: 220/255))
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
    var periodRest: Int = 0
    var roundRest: Int = 0
    var repeats: Int = 1
}

struct TimerEntry_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveView { layoutProperties in
            TimerEntryView(cuetimer: false, layoutProperties: layoutProperties).environmentObject(Entries())
        }
        
    }
}

