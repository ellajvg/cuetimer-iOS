//
//  LogoCreator.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-13.
//

import SwiftUI

struct LogoCreator: View {
    
    private var teal: Color = Color(red: 2/255, green: 128/255, blue: 146/255)
    
    private var red: Color = Color(red: 146/255, green: 2/255, blue: 2/255)
    
    private var blue: Color = Color(red: 2/255, green: 58/255, blue: 146/255)
    
    private var purple: Color = Color(red: 96/255, green: 48/255, blue: 126/255)
    
    private var gray: Color = Color(red: 80/255, green: 80/255, blue: 80/255)
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 43)
                .foregroundStyle(.white)
                .shadow(color: .gray.opacity(0.5), radius: 4, y: 5)
            Circle()
                .trim(from: 0.0, to: 0.5)
                .stroke(red, style: StrokeStyle(
                    lineWidth: 43,
                    lineCap: .butt,
                    lineJoin: .miter
                ))
                .rotationEffect(.degrees(-90))
            Circle()
                .trim(from: 0.3, to: 0.5)
                .stroke(red, style: StrokeStyle(
                    lineWidth: 43,
                    lineCap: .round,
                    lineJoin: .miter
                ))
                .rotationEffect(.degrees(-90))
            Rectangle()
                .frame(height: 60)
                .frame(width: 15)
                .offset(y: -106)
        }
        .padding(90)
    }
        
}

#Preview {
    LogoCreator()
}
