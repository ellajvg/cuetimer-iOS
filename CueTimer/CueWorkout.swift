//
//  CueWorkout.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-31.
//

import SwiftUI

struct CueWorkout: View {
    @EnvironmentObject var entries: Entries
    @State var currExercise: Int = 0
    @State var currSet: Int = 1
    @State var currSide: String = "R"
    @State var completed: Int = 1
    
    var totalSets: Int { calculateTotalSets(exercises: entries.exercises) }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    if currExercise < entries.exercises.count {
                        VStack(spacing: 30) {
                            Text(entries.exercises[currExercise].exercise)
                                .padding(.top, 20)
                                .font(.title)
                            
                            HStack {
                                Text("Set: \(currSet)/\(entries.exercises[currExercise].sets)")
                                Spacer()
                                if entries.exercises[currExercise].rightLeft {
                                    Text("Side: " + currSide)
                                    Spacer()
                                }
                                
                                Text("Reps: \(entries.exercises[currExercise].reps)")
                            }
                            .padding(.horizontal, 5)
                            .padding(.bottom, 5)
                        }
                        .frame(minHeight: 110)
                        .boxStyle(foregroundStyle: .white, background: .accentColor, shadowColor: .white)
                    } else {
                        VStack(spacing: 30) {
                            Text("Workout complete!")
                                .font(.title)
                        }
                        .frame(minHeight: 110)
                        .boxStyle(foregroundStyle: .white, background: .accentColor, shadowColor: .white)
                    }
                    Spacer()
                    VStack {
                        Text(findNextExercise())
                    }
                    .boxStyle(
                        foregroundStyle: .black,
                        background: Color(red: 196/255, green: 217/255, blue: 220/255),
                        shadowColor: .white
                    )
                }
                .padding(.horizontal, 5)
                .padding(.top, 20)
                .padding(.bottom, 20)
                .frame(height: 260)
                .boxStyle(
                    foregroundStyle: .black,
                    background: .white,
                    shadowColor: .gray
                )
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
                Text("Total: \(completed)/\(totalSets)")
                    .font(.largeTitle)
                    .foregroundStyle(Color.accentColor)
                    .padding(.top, 50)
                Spacer()
                HStack(spacing: 20) {
                    Button("Previous") {
                        if currExercise == entries.exercises.count {
                            currExercise -= 1
                            currSet = entries.exercises[currExercise].sets
                            if entries.exercises[currExercise].rightLeft {
                                currSide = "L"
                            }
                        } else if completed > 1 {
                            if entries.exercises[currExercise].rightLeft && currSide == "L" {
                                currSide = "R"
                            } else if currSet - 1 > 0 {
                                currSet -= 1
                                if entries.exercises[currExercise].rightLeft {
                                    currSide = "L"
                                }
                                completed -= 1
                            } else {
                                currExercise -= 1
                                currSet = entries.exercises[currExercise].sets
                                if entries.exercises[currExercise].rightLeft {
                                    currSide = "L"
                                }
                                completed -= 1
                            }
                            
                        }
                    }
                    .boxStyle(
                        foregroundStyle: .black,
                        background: .white,
                        shadowColor: .black
                    )
                    Button("Next") {
                        if currExercise < entries.exercises.count {
                            if entries.exercises[currExercise].rightLeft && currSide == "R" {
                                currSide = "L"
                            } else if currSet < entries.exercises[currExercise].sets {
                                currSet += 1
                                completed += 1
                                currSide = "R"
                            } else {
                                currExercise += 1
                                currSet = 1
                                currSide = "R"
                                
                                if completed < totalSets {
                                    completed += 1
                                }
                            }
                        }
                    }
                    .boxStyle(
                        foregroundStyle: .white,
                        background: Color.accentColor,
                        shadowColor: .black
                    )
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: CueEntry(cuetimer: false)) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title)
                            .foregroundColor(Color.accentColor)
                    }
                }
            }
            .background(
                Image("Background")
                    .ignoresSafeArea()
                    .offset(y:450)
            )
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func calculateTotalSets(exercises: [ExerciseEntry]) -> Int {
        var totalSets: Int = 0
        for exercise in entries.exercises {
            totalSets += exercise.sets
        }
        return totalSets
    }
    
    func findNextExercise() -> String {
        if currExercise < entries.exercises.count {
            if entries.exercises[currExercise].rightLeft && currSide == "R" {
                return "Next exercise: " + entries.exercises[currExercise].exercise
            } else if currSet < entries.exercises[currExercise].sets {
                return "Next exercise: " + entries.exercises[currExercise].exercise
            } else if currExercise+1 < entries.exercises.count {
                return "Next exercise: " + entries.exercises[currExercise+1].exercise
            } else if currExercise != entries.exercises.count && completed == totalSets {
                return "This is your last set!"
            }
        }
        return "Go flex in the mirror :)"
    }
}

 
struct CueWorkout_Previews: PreviewProvider {
    static var previews: some View {
        CueWorkout().environmentObject(Entries())
    }
}
 
