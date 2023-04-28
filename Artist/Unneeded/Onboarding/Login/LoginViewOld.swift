////
////  OnboardingThirdView.swift
////  Artist
////
////  Created by Vladislav Green on 3/7/23.
////
//
//import SwiftUI
//import LocalAuthentication
//import KeychainAccess
//
//
//struct LoginViewOld: View {
//    
//    @Binding var tabSelection: String
//    
//    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
//    @AppStorage("isNotLoggedIn") private var isNotLoggedIn = true
//    
//    @State private var login: String = ""
//    @State private var password: String = ""
//    
//    @State private var authenticationDidFail: Bool = false
//    @State private var authenticationDidSucceed: Bool = false
//    
//    var localAuthTypeText = "Face ID".localized
//    var localAuthTypeImage = Image(systemName: "faceid")
//    
//    var body: some View {
//        
//        ScrollView {
//            VStack {
//                Spacer(minLength: 150)
//                
//                Image(systemName: "wand.and.stars")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 160, height: 160, alignment: .center)
//                    .padding(.bottom, 48)
//                
//                Text("Welcome to the Artist App!")
//                    .font(CustomFont.heading.bold())
//                    .multilineTextAlignment(.center)
//                    .padding(.bottom, 24)
//                
//                Text("Please Login")
//                    .font(CustomFont.subheading)
//                    .padding(8)
//                
//                
//                VStack(spacing: -0.5) {
//                    TextField("Email", text: $login)
//                        .modifier(TextFielder())
//                    SecureField("Password", text: $password)
//                        .modifier(TextFielder())
//                }
//                .cornerRadius(12)
//                .padding(.top, 16)
//                .padding(.bottom, 8)
//                .padding(.leading, 16)
//                .padding(.trailing, 16)
//                
//                if authenticationDidFail {
//                    Text("Entered email or password isn't correct. Try again")
//                        .font(CustomFont.small)
//                        .foregroundColor(.red)
//                        .padding(.bottom, 8)
//                }
//                if !authenticationDidFail && !authenticationDidSucceed {
//                    Text("Enter your email and password and press Log In")
//                        .font(CustomFont.small)
//                        .foregroundColor(.textTertiary)
//                        .padding(.bottom, 8)
//                }
//                if !authenticationDidFail && authenticationDidSucceed {
//                    Text("Success!")
//                        .font(CustomFont.small)
//                        .foregroundColor(.accentColor)
//                        .padding(.bottom, 8)
//                }
//                
//                HStack {
//                    Button(action: {
//                        
//                        if checkUserCredentials(login: login, password: password) {
//                            self.authenticationDidSucceed = true
//                            self.authenticationDidFail = false
//                            isNotLoggedIn = false
//                            needsAppOnboarding = false
//                            print("logging in")
//                        } else {
//                            self.authenticationDidFail = true
//                            print("login failed")
//                            // ⭕️ ПРЕДЛОЖИТЬ ПЕРЕЙТИ НА ЭКРАН РЕГИСТРАЦИИ ИЛИ ПОПРОБОВАТЬ ЕЩЁ РАЗ
//                        }
//                        
//                    }) {
//                        Text("Log In".localized)
//                            .padding(.horizontal, 16)
//                            .padding(.vertical, 8)
//                            .font(CustomFont.heading.bold())
//                        }
//                        .background(Color.backgroundSecondary)
//                        .foregroundColor(.textPrimary)
//                        .cornerRadius(12)
//                        .padding([.leading])
//                    
//                        Spacer()
//                    
//                    Button(action: {
//                        authenticate()
//                    }) {
//                        Text(localAuthTypeText)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 8)
//                        .font(CustomFont.heading.bold())
//                        localAuthTypeImage
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 32, height: 32, alignment: .trailing)
//                    }
//                    .background(Color.backgroundTertiary)
//                    .foregroundColor(.textTertiary)
//                    .cornerRadius(12)
//                    .padding([.trailing])
//                }
//                
//                Spacer()
//                
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .background(Color.backgroundTertiary)
//        .foregroundColor(.textTertiary)
//        .ignoresSafeArea(.all, edges: .all)
////        .onAppear(perform: authenticate)
//        .adaptsToKeyboard()
//    }
//    
//    
//    func authenticate() {
//        let context = LAContext()
//        var error: NSError?
//
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "We need to unlock your data."
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                if success {
//                    isNotLoggedIn = false
//                } else {
//                    // there was a problem
//                    //
//                }
//            }
//        } else {
//            // no biometrics
//        }
//    }
//    
//    private func checkUserCredentials(login: String, password: String) -> Bool {
//        let keychain = Keychain()
//        do {
//            let truePassword = try keychain.get(login)
//            guard truePassword == password else {
//                return false
//            }
//            return true
//        } catch {
//            return false
//        }
//    }
// }
//
//struct LoginViewOld_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginViewOld(tabSelection: .constant("LoginView"))
//    }
//}
