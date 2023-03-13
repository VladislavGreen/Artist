//
//  ContentView.swift
//  Artist
//
//  Created by Vladislav Green on 3/7/23.
//  https://zendesk.engineering/app-onboarding-with-swiftui-23d970ab24d4

import SwiftUI


import SwiftUI

struct ContentView: View {
    
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    @AppStorage("isNotLoggedIn") private var isNotLoggedIn = true
    
    var body: some View {
        
        TabView() {
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill.checkmark")
                }
                .fullScreenCover(isPresented:$needsAppOnboarding) {
                    OnboardingView()
                }
                .fullScreenCover(isPresented:$isNotLoggedIn) {
                    LoginView(tabSelection: .constant("LoginView"))
                }
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "person.fill.checkmark")
                }
            EditView()
                .tabItem {
                    Label("Edit", systemImage: "person.fill.checkmark")
                }
                
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
