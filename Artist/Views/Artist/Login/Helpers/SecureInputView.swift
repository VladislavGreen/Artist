//
//  SecureInputView.swift
//  Artist
//
//  Created by Vladislav Green on 4/28/23.
//

import SwiftUI

struct SecureInputView: View {

    @Binding var isPasswordVisible: Bool
    @Binding var text: String
    var title: String
    
    var body: some View {
        
        if isPasswordVisible {
            TextField(title, text: $text)
        } else {
            SecureField(title, text: $text)
        }
    }
    
}

//struct SecureInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        SecureInputView()
//    }
//}
