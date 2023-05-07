//
//  AudioPlayerView.swift
//  Artist
//
//  Created by Vladislav Green on 3/22/23.
//  https://laurentbrusa.hashnode.dev/creating-an-accessible-audio-player-in-swiftui-part-1

import SwiftUI
import AVKit



struct AudioPlayerView: View {
    
    @ObservedObject private var audioManager = StreamManager.shared
    @State var size: CGSize = .zero
    @State var isMaximized = true
    
    var body: some View {
        
        if isMaximized {
            VStack {
                
                HStack(alignment: .center, spacing: 0) {
                    
                    Text(
                        audioManager.isPlaying
                        ? audioManager.currentTrack?.trackName ?? "Play me"
                        : (audioManager.currentTrack?.trackName ?? "Play me") + " [paused]" 
                    )
                    .lineLimit(1)
                    .font(CustomFont.small)
                    .foregroundColor(.accentColor)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                    .opacity(audioManager.isPlaying || audioManager.isPaused ? 1 : 0)
                    
                    Spacer()
                }
                
                HStack(alignment: .center, spacing: 28) {
                    
                    Spacer()
                    
                    Button(action: {
                        audioManager.isRepeating.toggle()
                    }) {
                        Image(systemName: audioManager.isRepeating ? "arrow.forward" : "repeat")
                            .font(CustomFont.title)
                            .imageScale(.small)
                    }
                    
                    Button(action: {
                        audioManager.rewind()
                    }) {
                        Image(systemName: "gobackward.15")
                            .font(CustomFont.title)
                            .imageScale(.medium)
                    }
                    
                    AudioPlayerPlayButton(isMaximized: $isMaximized)
                        .padding(.horizontal, 8)
                    
                    Button(action: {
                        audioManager.forward()
                    }) {
                        Image(systemName: "goforward.15")
                            .font(.title)
                            .imageScale(.medium)
                    }
                    
                    
                    
                    Button(action: {
                        isMaximized.toggle()
                    }) {
                        Image(systemName: "arrow.triangle.merge")
                            .font(.title)
                            .imageScale(.small)
                        
                    }
                    
                    Spacer()
                }
                
                HStack{
                    Text(audioManager.formattedProgress)
                        .font(.caption.monospacedDigit())   //This is to prevent the numbers from changing position when the kerning changes!
                        .foregroundColor(.accentColor)
                    
                    GeometryReader { geometryReader in
                        Capsule()
                            .stroke(Color.accentColor, lineWidth: 0.5)
                            .background(
                                Capsule()
                                    .foregroundColor(.accentColor)
                                    .frame(
                                        width: geometryReader.size.width * audioManager.progress,
                                        height:  8),
                                alignment: .leading)
                    }
                    .frame(height: 4)
                    
                    Text(audioManager.formattedDuration)
                        .font(.caption.monospacedDigit())
                        .foregroundColor(.accentColor)
                }
                .padding()
                .frame(height: 8)
                .accessibilityElement(children: .ignore)
                .accessibility(identifier: "player")
                .accessibilityLabel(Text(audioManager.isPlaying ? "Playing at " : "Duration"))
                .accessibilityValue(Text("\(audioManager.formattedProgress)"))
            }
            .padding(.bottom, 8)
            .background(Color.backgroundPrimary)
            .opacity(0.85)
        }
        else {
            VStack {
                Spacer ()
                HStack {
                    Spacer()
                    AudioPlayerPlayButton(isMaximized: $isMaximized)
                        .padding(.trailing, 8)
                }
                Spacer()
            }
        }
    }
}

struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioPlayerView()
    }
}
