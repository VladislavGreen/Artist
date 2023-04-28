//
//  TextFielder.swift
//  Artist
//
//  Created by Vladislav Green on 3/9/23.
//

import SwiftUI

struct TextFielder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 50)
            .padding(.leading, 12)
            .border(Color.textSecondary, width: 0.5)
            .background(Color.backgroundSecondary)
            .foregroundColor(.textPrimary)
    }
}
