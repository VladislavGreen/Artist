//
//  LoginButton.swift
//  Artist
//
//  Created by Vladislav Green on 3/22/23.
//

import SwiftUI

struct LoginButton: View {
    var pressed: () -> Void
    var body: some View {
        Button(action: pressed) {
            HStack {
                Text("Log In".localized)
            }
            .foregroundColor(.accentColor)
            .background(.clear)
        }
    }
}

struct SignUpButton: View {
    var pressed: () -> Void
    var body: some View {
        Button(action: pressed) {
            HStack {
                Text("Sign Up".localized)
            }
            .foregroundColor(.accentColor)
            .background(.clear)
        }
    }
}



//struct ProfileButton_Previews: PreviewProvider {
//    static var handler: () -> Void = {  }
//    
//    static var previews: some View {
//        ProfileButton(pressed: handler)
//    }
//}
