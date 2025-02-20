//
//  Intro.swift
//  CueTimer
//
//  Created by Ella Vanderkop-Girard on 2025-01-24.
//

import SwiftUI

struct HomepageView: View {
    @EnvironmentObject var entries: Entries
    @State private var logoScale: CGFloat = 1.0
    @State private var logoOffsetY: CGFloat = 0.0
    @State private var goToHomepage: Bool = false
    @State private var showAnimation: Bool
    @State private var animationCompleted: Bool
    
    let layoutProperties: LayoutProperties

    init(animationCompleted: Bool, layoutProperties: LayoutProperties) {
        self._showAnimation = State(initialValue: !animationCompleted)
        self._animationCompleted = State(initialValue: animationCompleted)
        self.layoutProperties = layoutProperties
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if !showAnimation {
                    VStack {
                        HStack {
                            Image(systemName: "person.fill")
                            Spacer()
                        }
                        .font(.system(size: layoutProperties.customFontSize.large))
                        .padding(.horizontal, 20)
                        .foregroundColor(Color.accentColor)
                        Spacer()
                        VStack {
                            NavigationLink("Timer", destination:
                                            TimerEntryView(cuetimer: false, layoutProperties: layoutProperties)
                            )
                            .boxStyle(
                                foregroundStyle: .white,
                                background: Color.accentColor,
                                shadowColor: .black
                            )
                            .padding(.bottom, 30)
                            NavigationLink("Exercise cues", destination: 
                                CueEntryView(cuetimer: false, layoutProperties: layoutProperties)
                            )
                            .boxStyle(
                                foregroundStyle: .white,
                                background: Color.accentColor,
                                shadowColor: .black
                            )
                            .padding(.bottom, 30)
                            NavigationLink("CueTimer", destination:
                                CueEntryView(cuetimer: true, layoutProperties: layoutProperties)
                            )
                            .boxStyle(
                                foregroundStyle: .black,
                                background: .white,
                                shadowColor: .black
                            )
                            .padding(.bottom, 30)
                        }
                        .font(.system(size: layoutProperties.customFontSize.smallMedium))
                        .padding(.horizontal, 80)
                        .padding(.bottom, 30)
                    }
                    .background(
                        Image("Background")
                            .resizable()
                            .ignoresSafeArea()
                            .offset(y:layoutProperties.customDimensValue.large)
                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    )
                    
                }
                Image("Logo3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: logoOffsetY)
                    .scaleEffect(logoScale)
                    .onAppear {
                        if !animationCompleted {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeOut(duration: 2)) {
                                    logoScale = 0.644
                                    logoOffsetY = -UIScreen.main.bounds.height / 2.984
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    goToHomepage = true
                                    animationCompleted = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        showAnimation = false
                                    }
                                }
                            }
                        } else {
                            logoScale = 0.644
                            logoOffsetY = -UIScreen.main.bounds.height / 2.984
                        }
                    }
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
        ResponsiveView { layoutProperties in
            HomepageView(animationCompleted: false, layoutProperties: layoutProperties)
        }
        .environmentObject(Entries())
    }
}



