//
//  TrackRow.swift
//  Artist
//
//  Created by Vladislav Green on 3/20/23.
//

import SwiftUI

struct TrackRow: View {
    
    var track: Track
    @ObservedObject var audioManager = AudioManager.shared
    
    var body: some View {
        
        
        HStack {
            
            Text("\(track.number)")
                .padding(.leading, 8)
            Text(track.trackName)
                .lineLimit(1)
                
            Spacer()
            
            Button {
                
                if audioManager.currentTrack == track.trackName,
                   audioManager.isPlaying {
                        audioManager.pause()
                }
                if audioManager.currentTrack != track.trackName,
                   audioManager.isPlaying {
//                        audioManager.pause()
                        audioManager.play(sound: track.trackName)
                        audioManager.currentTrack = track.trackName
                }
                if !audioManager.isPlaying  {
                        audioManager.play(sound: track.trackName)
                        audioManager.currentTrack = track.trackName
                }
            } label: {
                if audioManager.currentTrack == track.trackName,
                   audioManager.isPlaying {
                    Image(systemName: "pause.circle")
                        .font(CustomFont.subheading)
                        .imageScale(.medium)
                        .padding(.leading, 16)
                        .padding(.trailing, 8)
                } else {
                    Image(systemName: "play" )
                        .font(CustomFont.subheading)
                        .imageScale(.medium)
                        .padding(.leading, 16)
                        .padding(.trailing, 8)
                }
            }
                
        }
    }
}

struct TrackRow_Previews: PreviewProvider {
    static var artists = ArtistModelData().artists
    
    static var previews: some View {
        TrackRow(track: artists[0].releases[0].tracks[1])
    }
}
