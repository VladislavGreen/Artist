////
////  OnboardingView.swift
////  Artist
////
////  Created by Vladislav Green on 3/7/23.
////
//
//import SwiftUI
//
//struct WelcomeView: View {
//    
//    @Binding var tabSelection: String
//    
//    var body: some View {
//        
//        VStack {
//            
//            Spacer()
//            
//            Image(systemName: "wand.and.stars")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 80, height: 80, alignment: .center)
//                .padding(16)
//            
//            Text("Welcome to the Artist App!".localized)
//                .font(CustomFont.heading.bold().lowercaseSmallCaps())
//                .multilineTextAlignment(.center)
//                .padding(.bottom, 16)
//            
//            
//            Text("The simple and convient app will let you spread your music all over the world!".localized)
//                .font(CustomFont.subheading)
//                .multilineTextAlignment(.center)
//
//                .padding(16)
//            
//            VStack(alignment: .leading, spacing: 6) {
//                Text("- keep and manage your tracks in one place".localized)
//                    .font(CustomFont.subheading)
//                    .padding(.bottom, 2)
//                Text("- let people know what are you currently working on".localized)
//                    .font(CustomFont.subheading)
//                    .padding(.bottom, 2)
//                Text("- share your music directly or using Artist Hub".localized)
//                    .font(CustomFont.subheading)
//                    .padding(.bottom, 16)
//            }
//            .padding(32)
//            
//            
//            Text("Not registered yet? Press the Next button to join us!".localized)
//                .font(CustomFont.subheading)
//                .multilineTextAlignment(.center)
//                .padding(16)
//            
//            Button(action: {
//                tabSelection = "SignInView"
//            }) {
//                Text("Next".localized)
//                .padding(.horizontal, 42)
//                .padding(.vertical, 16)
//                .font(CustomFont.heading.bold())
//            }
//            .background(Color.backgroundPrimary)
//            .foregroundColor(.textPrimary)
//            .cornerRadius(40)
//            .padding(16)
//            
//            Spacer()
//                
//        }
//        .frame(maxWidth: .infinity)
//        .background(Color.backgroundTertiary)
//        .foregroundColor(.textTertiary)
//        .ignoresSafeArea(.all, edges: .all)
//    }
//}
//
//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView(tabSelection: .constant("WelcomeView"))
//    }
//}
