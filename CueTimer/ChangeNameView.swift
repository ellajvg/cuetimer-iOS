//
//  ChangeNameView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-31.
//

import SwiftUI

struct ChangeNameView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var workoutName: String = ""
    @Binding var showNamePopover: Bool
    @Binding var goToNextStep: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    showNamePopover = false
                } label: {
                    Image(systemName: "x.circle.fill")
                        .font(.title)
                        .foregroundStyle(themeManager.theme.darkColor)
                        .padding(.top)
                        .padding(.horizontal)
                }
            }
            
            
            VStack(spacing: 20) {
                VStack {
                    Text("Change name")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    Text("New name")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, -5)
                        .padding(.horizontal, 20)
                        
                    TextField("", text: $workoutName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: workoutName) { oldValue, newValue in
                            if oldValue != newValue {
                                dataManager.saveErrorText = ""
                                dataManager.showSaveError = false
                            }
                        }
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                    
                    if dataManager.showSaveError {
                        Text(dataManager.saveErrorText)
                            .font(.callout)
                            .foregroundStyle(themeManager.theme.darkColor)
                            .padding(.top, -15)
                            .padding(.bottom, 20)
                            .padding(.horizontal, 15)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 4, y: 4)
                HStack(spacing: 20) {
                    Button {
                        showNamePopover = false
                        goToNextStep = true
                    } label: {
                        Text("Don't save")
                            .boxStyle(foregroundStyle: .black, background: .white, shadowColor: .gray)
                    }
                    .growingButton()
                    Button {
                        if let userId = authManager.getUserId() {
                            dataManager.getDocumentId(userId: userId, name: workoutName) { docId in
                                if workoutName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    dataManager.saveErrorText = "Please enter a name for your workout."
                                    dataManager.showSaveError = true
                                } else if docId != nil {
                                    dataManager.saveErrorText = "You've already used this name. Please enter a different one!"
                                    dataManager.showSaveError = true
                                } else {
                                    dataManager.changeWorkoutName(userId: userId, oldName: workoutManager.name!, newName: workoutName) { success in
                                        if success {
                                            workoutManager.name = workoutName
                                        }
                                    }
                                    showNamePopover = false
                                    goToNextStep = true
                                }
                            }
                        }
                    } label: {
                        Text("Save")
                            .boxStyle(foregroundStyle: .white, background: themeManager.theme.darkColor, shadowColor: .gray)
                    }
                    .growingButton()
                }
            }
            .padding(.top, 5)
            .padding(.horizontal)
            .padding(.bottom)
            
            Spacer()
        }
    }
}


struct ChangeNameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeNameView(showNamePopover: .constant(true), goToNextStep: .constant(false))
            .environmentObject(DataManager())
            .environmentObject(AuthManager())
            .environmentObject(ThemeManager())
            .environmentObject(WorkoutManager())
    }
}

