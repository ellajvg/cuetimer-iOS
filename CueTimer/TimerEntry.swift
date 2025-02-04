//
//  TimerEntry.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-27.
//

import SwiftUI

struct TimerEntry: View {
    @EnvironmentObject var entries: Entries
    var cuetimer: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        Text("Work")
                            .font(.title2)
                        Image(systemName: "figure.strengthtraining.traditional")
                            .font(.title3)
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentColor)
                    .padding(.top, 10)
                        
                    ScrollViewReader { proxy in
                        List {
                            ForEach(entries.timer.workPeriods.indices, id: \.self) { index in
                                HStack {
                                    Text("Period \(index + 1)")
                                    Spacer()
                                    Picker("", selection: $entries.timer.workPeriods[index]) {
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
                            .background(Color(red: 196/255, green: 217/255, blue: 220/255))
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                        }
                        .frame(maxHeight: CGFloat(entries.timer.workPeriods.count * 55))
                        .listStyle(PlainListStyle())
                        .onChange(of: entries.timer.workPeriods.count) {
                            withAnimation {
                                proxy.scrollTo(entries.timer.workPeriods.indices.last, anchor: .bottom)
                            }
                        }
                    }
                    
                            
                    HStack {
                        Spacer()
                        Button(role: .destructive) {
                            if entries.timer.workPeriods.count > 1 {
                                entries.timer.workPeriods.removeLast()
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                        }
                        
                        Button {
                            entries.timer.workPeriods.append(30)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .foregroundStyle(Color.accentColor)
                    .font(.title3)
                    
                    HStack {
                        Text("Rest")
                            .font(.title2)
                        Image(systemName: "figure.cooldown")
                            .font(.title3)
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentColor)
                
                    HStack {
                        if entries.timer.workPeriods.count > 1 {
                            Text("Rest in between periods")
                        } else {
                            Text("Rest")
                        }
                        Spacer()
                        Picker("", selection: $entries.timer.periodRest) {
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
                    .padding(.vertical, 5)
                    .padding(.leading, 15)
                    .padding(.trailing, 5)
                    .background(Color(red: 196/255, green: 217/255, blue: 220/255))
                    .cornerRadius(10)
                    
                    if entries.timer.workPeriods.count > 1 {
                        HStack {
                            Text("Rest in between rounds")
                            Spacer()
                            Picker("", selection: $entries.timer.roundRest) {
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
                        .padding(.vertical, 5)
                        .padding(.leading, 15)
                        .padding(.trailing, 5)
                        .background(Color(red: 196/255, green: 217/255, blue: 220/255))
                        .cornerRadius(10)
                    }
                    
                    if !cuetimer {
                        HStack {
                            Text("Repeats")
                                .font(.title2)
                            Image(systemName: "repeat")
                                .font(.title3)
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                        .padding(.top, 20)
                        
                        HStack {
                            Text("Repeats")
                            Spacer()
                            Picker("", selection: $entries.timer.periodRest) {
                                ForEach(1...100, id: \.self) { number in
                                    Text("\(number)").tag(number)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .tint(.black)
                        }
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
                .padding(.bottom, 10)
                .padding(.top, 15)
                Spacer()
                NavigationLink("Start workout", destination: TimerEntry(cuetimer: true))
                    .boxStyle(
                        foregroundStyle: .white,
                        background: Color.accentColor,
                        shadowColor: .gray
                    )
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !cuetimer {
                        NavigationLink(destination: Homepage(animationCompleted: true)) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.title)
                                .foregroundColor(Color.accentColor)
                        }
                    } else {
                        NavigationLink(destination: CueEntry(cuetimer: true)) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.title)
                                .foregroundColor(Color.accentColor)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "info.circle.fill")
                        .font(.title)
                        .foregroundColor(Color.accentColor)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct Timer {
    var workPeriods: [Int] = []
    var periodRest: Int = 5
    var roundRest: Int = 5
    var repeats: Int = 1
}

struct TimerEntry_Previews: PreviewProvider {
    static var previews: some View {
        TimerEntry(cuetimer: true).environmentObject(Entries())
    }
}

