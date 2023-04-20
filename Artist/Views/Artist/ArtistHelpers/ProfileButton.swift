//
//  ProfileButton.swift
//  Artist
//
//  Created by Vladislav Green on 3/22/23.
//

import SwiftUI

struct ProfileButton: View {
    
    var pressed: () -> Void
    
    var body: some View {
        
        Button(action: pressed) {
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 48, height: 48)
            }
            .foregroundColor(.accentColor)
            .background(.clear)
        }
    }
}

struct ProfileButton_Previews: PreviewProvider {
    static var handler: () -> Void = {  }
    
    static var previews: some View {
        ProfileButton(pressed: handler)
    }
}
