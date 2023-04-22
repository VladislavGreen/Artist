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
            Image(release.imageCoverName ?? "No name")
                .renderingMode(.original)
                .resizable()
                .frame(width: 104, height: 104)
                .cornerRadius(4)
            VStack {
                Text(release.name)
                #if DEBUG
                Text(release.dateReleasedTS.formatted(date: .abbreviated, time: .omitted))
                #endif
            }
            .foregroundColor(.textPrimary)
            .font(.caption)
        }
        .padding(.leading, 16)
        .padding(.bottom, 16)
    }
}


//#if DEBUG
//struct ReleaseItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ReleaseItem(release: ArtistModelData().artists[0].releases[0])
//    }
//}
//#endif
