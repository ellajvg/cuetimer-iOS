//
//  CueInfoView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-12.
//

import SwiftUI

struct CueInfoView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var showCueInfo: Bool
    let cuetimer: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    showCueInfo = false
                } label: {
                    Image(systemName: "x.circle.fill")
                        .font(.title)
                        .foregroundStyle(themeManager.theme.darkColor)
                }
            }
            
            Text("Information")
                .font(.title)
                .fontWeight(.semibold)
            
            ScrollView {
                VStack(spacing: 15) {
                    VStack {
                        Text("Adding exercises to your workout")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                            .padding(.top, 5)
                        Image(cuetimer ? "CueTimerInfo\(themeManager.theme.themeName)" : "CueInfo\(themeManager.theme.themeName)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        VStack(spacing: 10) {
                            Text("**1. Enter a name** for your exercise.")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("**2. Choose the number of reps**—the number of times you perform the exercise in a row (e.g., 10 lunges = 10 reps). If you don't want reps to show up in your workout for this exercise, select N/A.")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("**3. Choose the number of sets**—groups of reps separated by a break (e.g., 4 sets of 10 lunges = 40 lunges total, 10 at a time).")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("**4. Enable R/L cues for unilateral exercises** (e.g., lunges). When enabled, sets for the exercise are doubled to include separate cues for the right and left sides (e.g., 4 sets with R/L enabled = 8 total sets, 4 per side).")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("**5. Click add exercise** to include it in your workout.")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(cuetimer ? "**6. Click edit timer** once you've addded all your exercises." : "**6. Click start workout** once you've addded all your exercises.")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if !cuetimer {
                                Text("**Note: If your workout isn't saved**, a popup will appear with the option to save your workout. Click save or don't save to start to your workout.")
                            }
                        }
                    }
                    Divider()
                    
                    VStack {
                        Text("Editing your workout")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.semibold)
                        Image("Reorder\(themeManager.theme.themeName)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        Text("Swipe right and click on the arrows to change the order of exercises.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 10)
                        Image("Delete\(themeManager.theme.themeName)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        Text("Swipe left and click on the bin to delete an exercise.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom, 30)
                    Spacer()
                }
            }
            .padding(.horizontal)
            .scrollIndicators(.hidden)
        }
        .padding()
    }
}

struct CueInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CueInfoView(showCueInfo: .constant(true), cuetimer: false)
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}
