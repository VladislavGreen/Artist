//
//  AvatarView.swift
//  Artist
//
//  Created by Vladislav Green on 3/14/23.
//

import SwiftUI

struct AvatarImageView: View {
    
    var imageName: String
    
    var body: some View {
   
        Image(imageName)
            .resizable()
            .clipShape(Rectangle())
            .scaledToFit()
            .shadow(radius: 4)
       
    }
}

struct AvatarImageView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarImageView(imageName: "Rockstar1")
    }
}
