//
//  FlagButton.swift
//  Artist
//
//  Created by Vladislav Green on 3/17/23.
//

import SwiftUI

struct FlagButton: View {
    
    @Binding var isSet: Bool
    
    var body: some View {
        
        Button {
            isSet.toggle()
        } label: {
            Label("Toggle Flag", systemImage: isSet ? "flag.fill" : "flag")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? .yellow : .gray)
        }
    }
}

struct FlagButton_Previews: PreviewProvider {
    static var previews: some View {
        FlagButton(isSet: .constant(true))
    }
}
