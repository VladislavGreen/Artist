//
//  TrackRow.swift
//  Artist
//
//  Created by Vladislav Green on 3/20/23.
//

import SwiftUI

struct TrackRow: View {
    
    var track: Track
    
    var body: some View {
        HStack {
            
            Text("\(track.number)")
                .padding(.leading, 8)
            Text(track.trackName + " Test TestTest TestTestTest Test")
                .lineLimit(1)
                
            Spacer()
            
            Image(systemName: "play")
                .padding(.leading, 16)
                .padding(.trailing, 8)
        }
    }
}

struct TrackRow_Previews: PreviewProvider {
    static var artists = ArtistModelData().artists
    
    static var previews: some View {
        TrackRow(track: artists[0].releases[0].tracks[0])
    }
}
