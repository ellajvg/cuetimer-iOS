//
//  Intro.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-24.
//

import SwiftUI
import FirebaseAuth

struct HomepageView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var entries: Entries
    @State private var logoScale: CGFloat = 1.0
    @State private var logoOffsetY: CGFloat = 0.0
    @State private var showPopover: Bool = false
    @State private var showDeletePopover: Bool = false
    
    @State var showAnimation: Bool
    let layoutProperties: LayoutProperties
    
    init(showAnimation: Bool = false, layoutProperties: LayoutProperties) {
        self.showAnimation = showAnimation
        self.layoutProperties = layoutProperties
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ZStack {
                    if !showAnimation {
                        VStack {
                            Spacer()
                            NavigationLink(destination:
                                            CueEntryView(cuetimer: true, layoutProperties: layoutProperties)) {
                                Text("CueTimer")
                                    .boxStyle(
                                        foregroundStyle: .white,
                                        background: themeManager.theme.darkColor,
                                        shadowColor: .gray
                                    )
                            }
                            .growingButton()
                            .padding(.bottom, 30)
                            NavigationLink(destination:
                                            TimerEntryView(cuetimer: false, layoutProperties: layoutProperties)) {
                                Text("Timer")
                                    .boxStyle(
                                        foregroundStyle: .black,
                                        background: .white,
                                        shadowColor: .gray
                                    )
                            }
                            .growingButton()
                            .padding(.bottom, 30)
                            NavigationLink(destination:
                                            CueEntryView(cuetimer: false, layoutProperties: layoutProperties)) {
                                Text("Exercise cues")
                                    .boxStyle(
                                        foregroundStyle: .black,
                                        background: .white,
                                        shadowColor: .gray
                                    )
                            }
                            .growingButton()
                            .padding(.bottom, 30)
                        }
                        .font(.system(size: layoutProperties.customFontSize.smallMedium))
                        .padding(.horizontal, 80)
                        .background(
                            VStack {
                                Spacer()
                                Circle()
                                    .fill(themeManager.theme.lightColor)
                                    .scaleEffect(2.3)
                                    .offset(y: layoutProperties.customDimensValue.large)
                            }
                            .ignoresSafeArea()
                        )
                        .transition(AnyTransition.move(edge: .bottom))
                    }
                    
                    Image("Logo\(themeManager.theme.themeName)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(y: showAnimation ? logoOffsetY : -UIScreen.main.bounds.height / 3.6)
                        .scaleEffect(showAnimation ? logoScale : 0.8)
                        .onAppear {
                            if showAnimation {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.easeOut(duration: 0.5)) {
                                        logoScale = 0.8
                                        logoOffsetY = -UIScreen.main.bounds.height / 3.6
                                        showAnimation = false
                                    }
                                }
                            }
                        }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showPopover = true
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: layoutProperties.customFontSize.mediumLarge * 1.1))
                                .foregroundColor(themeManager.theme.darkColor)
                        }
                    }
                }
            }
            .popover(isPresented: $showPopover) {
                TabView {
                    SavedView(layoutProperties: layoutProperties)
                        .tabItem {
                            Label("Saved", systemImage: "bookmark")
                        }
                       
                    HistoryView(layoutProperties: layoutProperties)
                        .tabItem {
                            Label("History", systemImage: "book")
                        }
                    
                    SettingsView(layoutProperties: layoutProperties)
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                }
                .tint(themeManager.theme.darkColor)
                .font(.system(size: layoutProperties.customFontSize.small))
            }
            
        }
        .onAppear {
            entries.reset()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveLayout { layoutProperties in
            HomepageView(showAnimation: true, layoutProperties: layoutProperties)
                .environmentObject(AuthManager())
                .environmentObject(ThemeManager())
                .environmentObject(Entries())
        }
    }
}



