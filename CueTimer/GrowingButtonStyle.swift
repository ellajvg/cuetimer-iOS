//
//  ShrinkingButtonStyle.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-12.
//

import SwiftUI

struct GrowingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension View {
    func growingButton() -> some View {
        self.buttonStyle(GrowingButtonStyle())
    }
}
