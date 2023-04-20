//
//  AudioPlayerPlayButton.swift
//  Artist
//
//  Created by Vladislav Green on 3/30/23.
//

import SwiftUI


struct AudioPlayerPlayButton: View {
    
    @EnvironmentObject var artist: Artist
    @ObservedObject private var audioManager = StreamManager.shared
    @Binding var isMaximased: Bool
    
    var body: some View {
        
        Button {
            
            guard !audioManager.isPlaying else {
                audioManager.pause()
                return
            }
            
            guard !audioManager.isPaused else {
                print("играем дальше прошлый трек")
                audioManager.continuePlayback()
                return
            }
            
            print("играем дефолтный плейлист")
            let releases = Array(artist.releases! as Set<Release>)
            audioManager.playTopPlaylist(releases: releases)
            
        } label: {
            Image(systemName: audioManager.isPlaying ? "pause.circle" : "play.circle" )
                .resizable()
                .frame(width: 48, height: 48)
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width < 0 {
                    // left
                }

                if value.translation.width > 0 {
                    // right
                }
                if value.translation.height < 0 {
                    // up
                    // Тут было бы здорово придумать анимацию
                    
                    isMaximased.toggle()
                }

                if value.translation.height > 0 {
                    isMaximased.toggle()                }
            }))
    }
}

struct AudioPlayerPlayButton_Previews: PreviewProvider {
    static var previews: some View {
        AudioPlayerPlayButton(isMaximased: .constant(true))
    }
}
