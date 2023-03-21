//
//  ReleaseDetail.swift
//  Artist
//
//  Created by Vladislav Green on 3/20/23.
//

import SwiftUI

struct ReleaseDetail: View {
    
    @EnvironmentObject var artistModelData: ArtistModelData
    
    var release: Release
    
    var body: some View {
        VStack {
            HStack {
                Text(release.name)
                    .font(CustomFont.heading)
            }
            release.imageCover
                .resizable()
                .frame(width: 300, height: 300)
            
            List {
                ForEach(release.tracks) { track in
                    TrackRow(track: track)
                }
                
            }
        }
    }
}

struct ReleaseDetail_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseDetail(release: ArtistModelData().artists[0].releases[1])
            .environmentObject(ArtistModelData())
    }
}
