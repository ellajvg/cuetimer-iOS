//
//  TimerInfoView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-12.
//

import SwiftUI

struct TimerInfoView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var showTimerInfo: Bool
    @State var showExample: Bool = false
    let cuetimer: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    showTimerInfo = false
                } label: {
                    Image(systemName: "x.circle.fill")
                        .font(.title)
                        .foregroundStyle(themeManager.theme.darkColor)
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                }
            }
            
            Text("Information")
                .font(.title)
                .fontWeight(.semibold)
            
            ScrollView {
                VStack {
                    Text("**1. Choose the work periods**—the duration of each exercise. Click the plus or minus icons to add or remove work periods.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                    
                    VStack {
                        Text("Work")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 5)
                        
                        HStack {
                            Text("Period 1")
                            Spacer()
                            HStack {
                                Text("30 sec")
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.footnote)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(themeManager.theme.lightColor)
                        .cornerRadius(10)
                        
                        HStack {
                            Text("Period 2")
                            Spacer()
                            HStack {
                                Text("30 sec")
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.footnote)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(themeManager.theme.lightColor)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                        
                        HStack(spacing: 10) {
                            Spacer()
                            Image(systemName: "minus.circle.fill")
                            Image(systemName: "plus.circle.fill")
                        }
                        .foregroundStyle(themeManager.theme.darkColor)
                        .font(.title3)
                    }
                    .font(.callout)
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 10) {
                        Text("**2. Choose the period rest**—the rest in between work periods. This option only applies if you have more than one work period.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("**3. Choose the round rest**—the rest in between rounds. If round rest is set to 0 seconds, the period rest (if specified) will be used instead.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom, 10)
                    
                    VStack {
                        Text("Rest")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 5)
                        
                        HStack {
                            Text("Period rest")
                            Spacer()
                            HStack {
                                Text("0 sec")
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.footnote)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(themeManager.theme.lightColor)
                        .cornerRadius(10)
                        
                        HStack {
                            Text("Round rest")
                            Spacer()
                            HStack {
                                Text("0 sec")
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.footnote)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(themeManager.theme.lightColor)
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                    }
                    .font(.callout)
                    .padding(.bottom, 10)
                    
                    Text("**4. Choose the rounds**—the amount of times your work periods repeat.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                    
                    VStack {
                        Text("Rounds")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 5)
                        
                        HStack {
                            Text("Rounds")
                            Spacer()
                            HStack {
                                Text("1")
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.footnote)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(themeManager.theme.lightColor)
                        .cornerRadius(10)
                    }
                    .font(.callout)
                    .padding(.bottom, 10)
                    
                    Text("**5. Click start workout** once you've finished creating your timer.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                    
                    Text("Start workout")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(themeManager.theme.darkColor)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 4, y: 4)
                        .font(.callout)
                        .padding(.bottom, 15)
                    
                    Text("**Note: If your workout isn't saved**, a popup will appear with the option to save your workout. Click save or don't save to start to your workout.")
                    
                    if showExample {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("**Example:** If you have 2 work periods and 2 rounds, this will be your workout:")
                            
                            HStack {
                                Divider()
                                    .frame(width: 3)
                                    .overlay(themeManager.theme.lightColor)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("**Round 1**")
                                    Text("Work period 1")
                                    Text("Period rest if > 0 sec, otherwise no rest")
                                    Text("Work period 2")
                                }
                            }
                            
                            Text("Round rest if > 0 sec, otherwise period rest")
                            
                            HStack {
                                Divider()
                                    .frame(width: 3)
                                    .overlay(themeManager.theme.lightColor)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("**Round 2**")
                                    Text("Work period 1")
                                    Text("Period rest if > 0 sec, otherwise no rest")
                                    Text("Work period 2")
                                }
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .opacity,
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ).animation(.easeInOut(duration: 0.1)))
                        .padding(.top, 10)
                    }
                    
                    Button {
                        withAnimation {
                            showExample.toggle()
                        }
                    } label: {
                        Text(showExample ? "Hide example" : "Give me an example")
                            .foregroundStyle(themeManager.theme.darkColor)
                            .padding(.top, 10)
                            .animation(.easeInOut(duration: 0), value: showExample)
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
        .padding()
    }
}

struct TimerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TimerInfoView(showTimerInfo: .constant(true), cuetimer: true)
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}
