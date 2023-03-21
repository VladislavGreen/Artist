//
//  ReleaseItem.swift
//  Artist
//
//  Created by Vladislav Green on 3/19/23.
//

import SwiftUI

struct ReleaseItem: View {
    
    var release: Release
    
    var body: some View {
        
        VStack(alignment: .leading) {
            release.imageCover
                .renderingMode(.original)
                .resizable()
                .frame(width: 104, height: 104)
                .cornerRadius(4)
            Text(release.name)
                .foregroundColor(.textPrimary)
                .font(.caption)
        }
        .padding(.leading, 16)
    }
}

struct ReleaseItem_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseItem(release: ArtistModelData().artists[0].releases[0])
    }
}
