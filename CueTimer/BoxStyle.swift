//
//  ButtonStyle.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-23.
//

import SwiftUI

struct BoxStyle: ViewModifier {
    let foregroundStyle: Color
    let background: Color
    let shadowColor: Color

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .foregroundStyle(foregroundStyle)
            .padding()
            .background(background)
            .cornerRadius(10)
            .shadow(color: shadowColor, radius: 5, y: 5)
    }
}

extension View {
    func buttonStyle(foregroundStyle: Color, background: Color, shadowColor: Color) -> some View {
        self.modifier(BoxStyle(foregroundStyle: foregroundStyle, background: background, shadowColor: shadowColor))
    }
}
