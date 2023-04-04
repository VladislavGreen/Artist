//
//  ReleaseDetail.swift
//  Artist
//
//  Created by Vladislav Green on 3/20/23.
//

import SwiftUI

struct ReleaseDetail: View {
    
    @EnvironmentObject var artistModelData: ArtistModelData
    @ObservedObject var audioManager = AudioManager.shared
    
    var release: Release
    
    var body: some View {
        VStack {
            HStack {
                Text(release.name)
                    .font(CustomFont.heading)
                    .padding(8)
                    .lineLimit(1)
            }
            ZStack {
                HStack {
                    release.imageCover
                        .resizable()
                        .cornerRadius(0)
                }
                
                Button(action: {
                    guard !audioManager.isPlaying else {
                        audioManager.pause()
                        return
                    }
                    audioManager.playPlaylist(tracks: release.tracks)
                }) {
                    Image(systemName: "play.fill")
                        .font(CustomFont.title)
                        .imageScale(.medium)
                }
                .zIndex(1)
            }
            
            List {
                ForEach(release.tracks) { track in
                    
                    HStack {
                        VStack {
                            TrackRow(track: track)
                                .contextMenu {
                                    Group {
                                        Button("Go to artist", action: showArtist)
                                        Button("Add to playlist", action: addToPlaylist)
                                    }
                                }
                        }
                        
                        Button {
                            
                            self.trackPlayButtonAction(track: track)
                            
                        } label: {
                            
                            Image(systemName: self.trackPlayButtonLabel(track: track))
                                .font(CustomFont.subheading)
                                .imageScale(.medium)
                                .padding(.leading, 16)
                                .padding(.trailing, 8)
                            
                        }
                    }
                }
            }
        }
    }
    
    func showArtist() {
        print("⭕️ Микроменю: переход к исполнителю")
    }
    func addToPlaylist() {
        print("⭕️ Микроменю: создание/выбор плейлиста для добавления трека")
    }
    
    private func trackPlayButtonAction(track: Track) {
        if audioManager.currentTrack?.id == track.id,
           audioManager.isPlaying {
                audioManager.pause()
        }
        if audioManager.currentTrack?.id != track.id,
           audioManager.isPlaying {
                audioManager.play(track: track)
        }
        if !audioManager.isPlaying  {
                audioManager.play(track: track)
        }
    }
    
    // 🛑 НЕ РАБОТАЕТ ТОЛКОМ:
    private func trackPlayButtonLabel(track: Track) -> String {
        if audioManager.currentTrack?.id == track.id,
           audioManager.isPlaying {
            return "pause.circle"
        } else {
            return "play"
        }
    }
    
}

struct ReleaseDetail_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseDetail(release: ArtistModelData().artists[0].releases[1])
            .environmentObject(ArtistModelData())
    }
}
