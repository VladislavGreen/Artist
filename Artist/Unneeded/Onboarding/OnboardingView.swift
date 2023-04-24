//
//  OnboardingView.swift
//  Artist
//
//  Created by Vladislav Green on 3/7/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var tabSelection = ""
    
    var body: some View {
        TabView(selection: $tabSelection) {
            WelcomeView(tabSelection: $tabSelection)
                .tag("WelcomeView")
            SignInView(tabSelection: $tabSelection)
                .tag("SignInView")
            LoginViewOld(tabSelection: $tabSelection)
                .tag("LoginView")
        }
        .tabViewStyle(PageTabViewStyle())
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .ignoresSafeArea(.all, edges: .all)

    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
