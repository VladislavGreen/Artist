//
//  SignUpView.swift
//  Artist
//
//  Created by Vladislav Green on 4/28/23.
//

import SwiftUI
import KeychainAccess

struct SignUpView: View {
    
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    @Environment(\.dismiss) var dismiss
    
    @State private var userEmail: String = ""
    @State private var isEmailValid: Bool = true
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    @State private var isPasswordValid: Bool = true
    
    @State private var isPasswordVisible = false
    
    @FocusState private var emailInFocus: Bool
    @FocusState private var passwordInFocus: Bool
    
    @State private var showingEmailIsntCorrectAlert = false
    @State private var showingPasswordDontMatchAlert = false
    @State private var showingPasswordIsNotValidAlert = false
    
    var body: some View {
        
        ScrollView {
            
            Spacer()
            
            Text("Enter your Email and a password with confirmation. The password should be longer then two digits".localized)
                .padding()
            
            VStack(spacing: -0.5) {
                
                TextField("Email".localized, text: $userEmail, onEditingChanged: { isChanged in
                    if !isChanged {
                        if textFieldValidatorEmail(userEmail) {
                            isEmailValid = true
                        } else {
                            isEmailValid = false
                            userEmail = ""
                            showingEmailIsntCorrectAlert = true
                            emailInFocus = true
                        }
                    }
                })
                    .modifier(TextFielder())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .focused($emailInFocus)
                    .alert("Entered email address doesn't look correct".localized,
                           isPresented: $showingEmailIsntCorrectAlert) {
                        Button("Fix".localized, role: .cancel) {
                            userEmail = ""
                        }
                    }
                SecureInputView(
                    isPasswordVisible: $isPasswordVisible,
                    text: $password,
                    title: "Password".localized
                )
                    .modifier(TextFielder())
                    .textContentType(.password)
                    .focused($passwordInFocus)
                    .onSubmit {
                        if secureFieldValidatorPassword(password) {
                            isPasswordValid = true
                        } else {
                            isPasswordValid = false
                            password = ""
                            showingPasswordIsNotValidAlert = true
                            passwordInFocus = true
                        }
                    }
                    .alert("Entered password is too short. There must be more than 2 symbols".localized,
                           isPresented: $showingPasswordIsNotValidAlert) {
                        Button("Fix".localized, role: .cancel) {
                            password = ""
                        }
                    }
                SecureInputView(
                    isPasswordVisible: $isPasswordVisible,
                    text: $passwordConfirmation,
                    title: "Password confirmation".localized
                )
                .textContentType(.password)
                .modifier(TextFielder())
            }
            .cornerRadius(12)
            .padding(.top, 48)
            .padding(.bottom, 8)
            .padding(.leading, 16)
            .padding(.trailing, 16)
            
            
            HStack {
                Button(action: {

                    if self.password == self.passwordConfirmation {
                        createNewAccount(userEmail: userEmail, password: password)
                        dismiss()
                        print("logging in")
                    } else {
                        showingPasswordDontMatchAlert = true
                        print("login failed")
                    }

                }) {
                    Text("Create account".localized)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .font(CustomFont.heading.bold())
                    }
                    .background(Color.backgroundSecondary)
                    .foregroundColor(.textPrimary)
                    .cornerRadius(12)
                    .padding([.leading])
                    .alert("Password and password confitmation don't match. Please retry", isPresented: $showingPasswordDontMatchAlert) {
                        Button("Fix".localized, role: .cancel) {
                            password = ""
                            passwordConfirmation = ""
                        }
                    }
                    Spacer()
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                }
                .padding(.trailing, 16)
            }
            Spacer()
        }
        .background(Color.backgroundTertiary)
        .foregroundColor(.textTertiary)
    }
    
    
    private func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
//        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        // Временно упрощаем: минимум три цифры
//        let emailFormat = "^(?=.*[0-9]).{3,}$"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    private func secureFieldValidatorPassword(_ string: String) -> Bool {
        
        // One big letter, one special character and minimum six char long.
//        let passwordFormat = "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$"
        
        // Временно упрощаем: минимум три цифры
        let passwordFormat = "^(?=.*[0-9]).{3,}$"
        
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: string)
    }
    
    
    private func createNewAccount(userEmail: String, password: String) {
        let keychain = Keychain()
        do {
            try keychain.set(password, key: userEmail)
        } catch let error {
            print(error)
            print("Error saving userEmail and Password")
        }
        
        isLoggedIn = true
    }
    
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
