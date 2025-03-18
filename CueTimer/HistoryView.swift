//
//  HistoryView.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-03-12.
//

import SwiftUI

struct HistoryView: View {
    let layoutProperties: LayoutProperties
    var body: some View {
        Text("Hello history")
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveLayout { layoutProperties in
            HistoryView(layoutProperties: layoutProperties)
                .environmentObject(AuthManager())
                .environmentObject(ThemeManager())
                .environmentObject(Entries())
        }
        
    }
}

