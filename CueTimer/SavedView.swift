//
//  SavedView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-12.
//

import SwiftUI

struct SavedView: View {
    let layoutProperties: LayoutProperties
    var body: some View {
        Text("Hello saved")
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveLayout { layoutProperties in
            SavedView(layoutProperties: layoutProperties)
                .environmentObject(AuthManager())
                .environmentObject(ThemeManager())
                .environmentObject(Entries())
        }
        
    }
}

