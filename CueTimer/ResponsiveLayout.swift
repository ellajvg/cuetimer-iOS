//
//  ResponsiveView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-02-10.
//

import SwiftUI

struct ResponsiveLayout<Content: View>: View {
    var content:(LayoutProperties) -> Content
    var body: some View {
        GeometryReader {geo in
            let height = geo.size.height
            let width = geo.size.width
            let customDimensValue = CustomDimensValue(height:height, width:width)
            let customFontSize = CustomFontSize(height:height, width:width)
            content(
                LayoutProperties(
                    customDimensValue: customDimensValue,
                    customFontSize: customFontSize,
                    height: height,
                    width: width
                )
            )
        }
    }
}

struct CustomFontSize {
    let small: CGFloat
    let smallMedium: CGFloat
    let medium: CGFloat
    let mediumLarge: CGFloat
    let large: CGFloat
    let extraLarge: CGFloat
    let giant: CGFloat
    
    init(height: CGFloat, width: CGFloat) {
        if width > 700 {
            small = 22
            smallMedium = 30
            medium = 40
            mediumLarge = 45
            large = 50
            extraLarge = 100
            giant = 200
        } else {
            small = 17
            smallMedium = 20
            medium = 26
            mediumLarge = 29
            large = 30
            extraLarge = 60
            giant = 100
        }
    }
}

struct CustomDimensValue {
    let extraSmall: CGFloat
    let small: CGFloat
    let smallMedium: CGFloat
    let medium: CGFloat
    let mediumLarge: CGFloat
    let large: CGFloat
    let extraLarge: CGFloat
    
    
    init(height: CGFloat, width: CGFloat) {
        if width > 700 {
            extraSmall = 30
            small = 45
            smallMedium = 100
            medium = 100
            mediumLarge = 200
            large = 900
            extraLarge = 650
        } else {
            extraSmall = 20
            small = 30
            smallMedium = 40
            medium = 66
            mediumLarge = 90
            large = 260
            extraLarge = 450
        }
    }
}

struct LayoutProperties {
    var customDimensValue: CustomDimensValue
    var customFontSize: CustomFontSize
    var height: CGFloat
    var width: CGFloat
}

