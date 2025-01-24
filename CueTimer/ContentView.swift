//
//  ContentView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "house.fill")
                Spacer()
                Image(systemName: "person.fill")
            
            }
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.horizontal, 30)
            .foregroundColor(Color.accentColor)
            
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 60)
                .padding(.bottom, 60)
                .padding(.horizontal, 100)
            
            VStack {
                Spacer()
                Button("TIMER") {
                        
                }.buttonStyle(
                    foregroundStyle: .white,
                    background: Color.accentColor
                )
                Spacer()
                    
                Button("EXERCISE CUES") {
                        
                }.buttonStyle(
                    foregroundStyle: .white,
                    background: Color.accentColor
                )
                Spacer()
                    
                Button("CUES + TIMER") {
                        
                }
                .buttonStyle(
                    foregroundStyle: .black,
                    background: .white
                )
                Spacer()
            }
            .padding(30)
            .padding(.top, 30)
            
        }
        .background(
            Image("Background")
                .ignoresSafeArea()
                .offset(y:250)
        )
        
    }
}

#Preview {
    ContentView()
}
