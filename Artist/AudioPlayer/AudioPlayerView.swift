//
//  AudioPlayerView.swift
//  Artist
//
//  Created by Vladislav Green on 3/22/23.
//  https://laurentbrusa.hashnode.dev/creating-an-accessible-audio-player-in-swiftui-part-1

import SwiftUI
import AVKit



struct AudioPlayerView: View {
    
    @ObservedObject private var audioManager = AudioManager.shared
    var trackName = "TÆT Minus Five"
    @State var size: CGSize = .zero

    
    var body: some View {
        VStack {
            
            HStack(alignment: .center, spacing: 20) {
                
                Spacer()
                
                Button(action: {
                    audioManager.isRepeating.toggle()
                }) {
                    Image(systemName: audioManager.isRepeating ? "arrow.forward" : "repeat")
                        .font(CustomFont.title)
                        .imageScale(.medium)
                }
                
                Button(action: {
                    audioManager.rewind()
                }) {
                    Image(systemName: "gobackward.15")
                        .font(CustomFont.title)
                        .imageScale(.medium)
                }
                
                Button {
                    audioManager.isPlaying.toggle()
                    
                    if audioManager.isPlaying {
                        audioManager.play(sound: trackName)
                    } else {
                        audioManager.pause()
                    }
                } label: {
                    Image(systemName: audioManager.isPlaying ? "pause.circle" : "play" )
                        .font(CustomFont.title)
                        .imageScale(.large)
                }
                
                Button(action: {
                    audioManager.forward()
                }) {
                    Image(systemName: "goforward.15")
                        .font(.title)
                        .imageScale(.medium)
                }
                 
                Spacer()
            }
            .padding(.top, 16)
            
            HStack{
                Text(audioManager.formattedProgress)
                    .font(.caption.monospacedDigit())   //This is to prevent the numbers from changing position when the kerning changes!
                    .foregroundColor(.accentColor)
                
                GeometryReader { geometryReader in
                    Capsule()
                        .stroke(Color.accentColor, lineWidth: 1)
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
            .accessibilityLabel(audioManager.isPlaying ? Text("Playing at ") : Text("Duration"))
            .accessibilityValue(Text("\(audioManager.formattedProgress)"))
        }
        .background(Color.backgroundPrimary)
        .opacity(0.85)
    }
}

struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioPlayerView()
    }
}
