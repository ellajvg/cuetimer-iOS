//
//  CueInfoView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-12.
//

import SwiftUI

struct CueInfoView: View {
    let layoutProperties: LayoutProperties
    
    var body: some View {
        VStack {
            Text("Information")
                .font(.system(size: layoutProperties.customFontSize.large))
                .fontWeight(.semibold)
                .padding(.top, 30)
            
            VStack {
                Text("Adding exercises")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.semibold)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                Text("1. Enter a name for your exercise here in the textfield under \"Exercise\"")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                Text("2. REPS: Specify the reps for the exercise. Reps are the number of times do the exercise (i.e., 10 squats is the same as 10 reps of squats).")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                VStack {
                    Text("2. Specify the reps for the exercise. Reps are the number of times do the exercise (i.e., 10 squats is the same as 10 reps of squats).")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image("ExerciseEntry")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .padding(.horizontal, 20)
                
                VStack {
                    Text("1. Enter a name for your exercise here: ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image("ExerciseEntry")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .padding(.horizontal, 20)
                
                Divider()
                    .frame(height: 0.3)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                
                HStack {
                    Image(systemName: "speaker.wave.2")
                        .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                        .foregroundStyle(Color.darkAccent)
                    Text("Volume")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)
            
            VStack {
                Text("Editing exercises")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.semibold)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                HStack {
                    Image(systemName: "at")
                        .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                        .foregroundStyle(Color.darkAccent)
                    Text("Change email")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                Divider()
                    .frame(height: 0.3)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                HStack {
                    Image(systemName: "key")
                        .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                        .foregroundStyle(Color.darkAccent)
                    Text("Change password")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                Divider()
                    .frame(height: 0.3)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                        .foregroundStyle(Color.darkAccent)
                    Text("Logout")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                Divider()
                    .frame(height: 0.3)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                HStack {
                    Image(systemName: "trash")
                        .frame(width: layoutProperties.customFontSize.small * 1.5,  alignment: .leading)
                        .foregroundStyle(Color.darkAccent)
                    Text("Delete account")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)
            Spacer()
        }
        .font(.system(size: layoutProperties.customFontSize.small))
        .padding()
        
//        VStack(spacing: 0) {
//            Text("Swipe left to delete")
//                .font(.system(size: layoutProperties.customFontSize.small * 1.1))
//                .fontWeight(.semibold)
//                .padding(.top, 20)
//                .padding(.horizontal, 10)
//            
//            Image("Delete")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .padding()
//            
//            Text("Swipe right to reorder")
//                .font(.system(size: layoutProperties.customFontSize.small * 1.1))
//                .fontWeight(.semibold)
//                .padding(.top, 10)
//                .padding(.horizontal, 10)
//            
//            Image("Reorder")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .padding()
//
//            Divider()
//                .frame(maxWidth: .infinity)
//                .frame(height: 0.3)
//                .background(Color.gray.opacity(0.1))
//           
//            Button("Got it!") {
//                //showCueInfo = false
//            }
//            .fontWeight(.semibold)
//            .padding(15)
//            .foregroundStyle(Color.darkAccent)
//            .font(.system(size: layoutProperties.customFontSize.small * 1.1))
//        }
//        .frame(maxWidth: .infinity)
//        .foregroundStyle(.black)
//        .background(.white)
//        .cornerRadius(10)
//        .shadow(color: .gray, radius: 5, y: 5)
//        .padding(.horizontal, 50)
//        .padding(.bottom, 60)
    }
}

struct CueInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveLayout { layoutProperties in
            CueInfoView(layoutProperties: layoutProperties)
        }
        
    }
}
