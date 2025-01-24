//
//  ButtonStyle.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-23.
//

import SwiftUI

struct ButtonStyle: ViewModifier {
    let foregroundStyle: Color
    let background: Color
    private let shadowColor: Color = .black

    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(foregroundStyle)
            .padding()
            .background(background)
            .cornerRadius(10)
            .shadow(color: shadowColor, radius: 5, y: 5)
    }
}

extension View {
    func buttonStyle(foregroundStyle: Color, background: Color) -> some View {
        self.modifier(ButtonStyle(foregroundStyle: foregroundStyle, background: background))
    }
}
