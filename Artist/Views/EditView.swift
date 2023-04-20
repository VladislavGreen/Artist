//
//  EditView.swift
//  Artist
//
//  Created by Vladislav Green on 3/10/23.
//

import SwiftUI
import KeychainAccess

struct EditView: View {
    
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    @AppStorage("isNotLoggedIn") private var isNotLoggedIn = false
    
    var body: some View {
        
        VStack {
            
            Text("EditView (Пока здесь временные служебные кнопки и эксперименты")
            
            AudioPlayerView()
            
            Button(action: {
                isNotLoggedIn = true
                
            }) {
                Text("Log Out")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .font(CustomFont.heading.bold())
                }
                .background(Color.backgroundTertiary)
                .foregroundColor(.textTertiary)
                .cornerRadius(12)
                .padding([.leading])
            
            Button(action: {
                needsAppOnboarding = true
                
            }) {
                Text("Reset Onboarding")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .font(CustomFont.heading.bold())
                }
                .background(Color.backgroundTertiary)
                .foregroundColor(.textTertiary)
                .cornerRadius(12)
                .padding([.leading])
            
            Button(action: {
                let keychain = Keychain()
                do {
                    try keychain.remove("1234")
                } catch let error {
                    print("error: \(error)")
                }
                
            }) {
                Text("Remove keychain user '1234'")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .font(CustomFont.heading.bold())
                }
                .background(Color.backgroundTertiary)
                .foregroundColor(.textTertiary)
                .cornerRadius(12)
                .padding([.leading])
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
