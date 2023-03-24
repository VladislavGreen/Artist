//
//  FieldSeparator.swift
//  Artist
//
//  Created by Vladislav Green on 3/20/23.
//

import SwiftUI

struct FieldSeparator: View {
    
    var title: String
    
    var body: some View {
        
        
        
        HStack {
            Text(title)
                .padding(.leading, 16)
                .font(CustomFont.heading)
            Spacer()
            Text("see all")
                .padding(.trailing, 16)
                .foregroundColor(.accentColor)
        }
        .padding(.top, 8)
        
        
        
    }
}

struct FieldSeparator_Previews: PreviewProvider {
    static var previews: some View {
        FieldSeparator(title: "Hello World")
    }
}
