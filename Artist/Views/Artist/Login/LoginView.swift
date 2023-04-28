//
//  LoginView.swift
//  Artist
//
//  Created by Vladislav Green on 4/24/23.
//

import SwiftUI
import LocalAuthentication
import KeychainAccess

struct LoginView: View {
    
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showingSignUp = false
    
    @State private var login: String = ""
    @State private var password: String = ""
    
    @State private var authenticationDidFail: Bool = false
    @State private var authenticationDidSucceed: Bool = false
    
    var localAuthTypeText = "Face ID".localized
    var localAuthTypeImage = Image(systemName: "faceid")
    
    var body: some View {
        
        ScrollView {
            
            Text("Welcome to the Artist App!".localized)
                .font(CustomFont.heading.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 48)
                .padding(.bottom, 24)
            
            Spacer()
            
            HStack {
                Text("Haven't registered yet?".localized)
                SignUpButton() {
                    showingSignUp.toggle()
                }
                .sheet(isPresented: $showingSignUp) {
                    SignUpView()
                }
            }
            
            Spacer()
            
            Text("Please Login".localized)
                .font(CustomFont.subheading)
                .padding(8)
            
            VStack(spacing: -0.5) {
                TextField("Email".localized, text: $login)
                    .modifier(TextFielder())
                SecureField("Password".localized, text: $password)
                    .modifier(TextFielder())
            }
            .cornerRadius(12)
            .padding(.top, 16)
            .padding(.bottom, 8)
            .padding(.leading, 16)
            .padding(.trailing, 16)
            
            if authenticationDidFail {
                Text("Entered email or password isn't correct. Try again".localized)
                    .font(CustomFont.small)
                    .foregroundColor(.red)
                    .padding(.bottom, 8)
            }
            if !authenticationDidFail && !authenticationDidSucceed {
                Text("Enter your email and password and press Log In".localized)
                    .font(CustomFont.small)
                    .foregroundColor(.textTertiary)
                    .padding(.bottom, 8)
            }
            if !authenticationDidFail && authenticationDidSucceed {
                Text("Success!".localized)
                    .font(CustomFont.small)
                    .foregroundColor(.accentColor)
                    .padding(.bottom, 8)
            }
            
            HStack {
                Button(action: {
                    if checkUserCredentials(login: login, password: password) {
                        self.authenticationDidSucceed = true
                        self.authenticationDidFail = false
                        isLoggedIn = true
                        print("logging in")
                    } else {
                        self.authenticationDidFail = true
                        print("login failed")
                    }
                    
                }) {
                    Text("Log In".localized)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .font(CustomFont.heading)
                    }
                    .background(Color.backgroundSecondary)
                    .foregroundColor(.textPrimary)
                    .cornerRadius(12)
                    .padding([.leading])
                
                    Spacer()
                
                    Button(action: {
                        authenticate()
                    }) {
                        Text(localAuthTypeText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .font(CustomFont.heading)
                        localAuthTypeImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32, alignment: .trailing)
                    }
                    .background(Color.backgroundTertiary)
                    .foregroundColor(.textTertiary)
                    .cornerRadius(12)
                    .padding([.trailing])
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundTertiary)
        .foregroundColor(.textTertiary)
        .ignoresSafeArea(.all, edges: .all)
        .onAppear(perform: authenticate)
    }
    
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isLoggedIn = true
                }
            }
        }
    }
    
    private func checkUserCredentials(login: String, password: String) -> Bool {
        let keychain = Keychain()
        do {
            let truePassword = try keychain.get(login)
            guard truePassword == password else {
                return false
            }
            return true
        } catch {
            return false
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
