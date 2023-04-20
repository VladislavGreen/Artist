//
//  TrackRow.swift
//  Artist
//
//  Created by Vladislav Green on 3/20/23.
//

import SwiftUI

struct TrackRow: View {
    
    var track: Track
    @ObservedObject var audioManager = StreamManager.shared
    
    var body: some View {
        
        HStack {
            
            Text("\(track.number)")
                .padding(.leading, 8)
            
            Text(track.trackName ?? "No name")
                .lineLimit(1)
                
            Spacer()
            
        }
    }
}

//struct TrackRow_Previews: PreviewProvider {
////    static var artists = ArtistModelData().artists
//    
//    
//    static var previews: some View {
//        TrackRow(track: artists[0].releases[0].tracks[1])
//    }
//}
