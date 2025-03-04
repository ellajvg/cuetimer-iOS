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
                        .font(.system(size: layoutProperties.customFontSize.large * 1.4))
                        .padding(.horizontal, 20)
                        .foregroundColor(Color.darkAccent)
                        Spacer()
                        VStack {
                            NavigationLink("CueTimer", destination:
                                CueEntryView(cuetimer: true, layoutProperties: layoutProperties)
                            )
                            .boxStyle(
                                foregroundStyle: .white,
                                background: Color.darkAccent,
                                shadowColor: Color(red: 50/256, green: 50/256, blue: 50/256)
                            )
                            .padding(.bottom, 30)
                            NavigationLink("Timer", destination:
                                            TimerEntryView(cuetimer: false, layoutProperties: layoutProperties)
                            )
                            .boxStyle(
                                foregroundStyle: .black,
                                background: .white,
                                shadowColor: Color(red: 75/256, green: 75/256, blue: 75/256)
                            )
                            .padding(.bottom, 30)
                            NavigationLink("Exercise cues", destination: 
                                CueEntryView(cuetimer: false, layoutProperties: layoutProperties)
                            )
                            .boxStyle(
                                foregroundStyle: .black,
                                background: .white,
                                shadowColor: Color(red: 75/256, green: 75/256, blue: 75/256)
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
                                withAnimation(.easeOut(duration: 1.5)) {
                                    logoScale = 0.8
                                    logoOffsetY = -UIScreen.main.bounds.height / 3.6
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    goToHomepage = true
                                    animationCompleted = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        showAnimation = false
                                    }
                                }
                            }
                        } else {
                            logoScale = 0.8
                            logoOffsetY = -UIScreen.main.bounds.height / 3.6
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



