//
//  AudioPlayer.swift
//  Artist
//
//  Created by Vladislav Green on 3/23/23.
//  https://laurentbrusa.hashnode.dev/creating-an-accessible-audio-player-in-swiftui-part-2

import Foundation
import AVKit


final class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    static let shared = AudioManager()
    
    @Published public var isPlaying: Bool = false
    @Published public var isRepeating = false
    @Published public var progress: CGFloat = 0.0
    @Published public var duration: Double = 0.0
    @Published public var formattedDuration: String = ""
    @Published public var formattedProgress: String = "00:00"
    @Published public var currentTrack: String = ""
    
    private var audioPlayer: AVAudioPlayer?
    
    public var volume: Double = 1 {
        didSet {
            audioPlayer?.volume = Float(volume)
        }
    }
    
    
    private func prepareToPlay(sound: String, soundExtension: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: soundExtension) else {
            print("Failed to find \(sound) in bundle 1.")
            return
        }

        guard let player = try? AVAudioPlayer(contentsOf: url) else {
            print("Failed to load \(sound) from bundle.")
            return
        }
        self.audioPlayer = player
        self.audioPlayer?.prepareToPlay()

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]

        formattedDuration = formatter.string(from: TimeInterval(self.audioPlayer?.duration ?? 0.0))!
        duration = self.audioPlayer?.duration ?? 0.0    // used when forwarding

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let player = self.audioPlayer {
                if !player.isPlaying {
                    self.isPlaying = false
                }
                self.progress = CGFloat(player.currentTime / player.duration)
                self.formattedProgress = formatter.string(from: TimeInterval(player.currentTime))!
            }
        }
        audioPlayer?.delegate = self
    }
    
    
    public func play(sound: String) {
        let soundExtension = ".mp3"
        audioPlayer?.stop()
        prepareToPlay(sound: sound, soundExtension: soundExtension)
        currentTrack = sound
        isPlaying = true
        audioPlayer?.setVolume((0), fadeDuration: 0.1)
        audioPlayer?.play()
        audioPlayer?.setVolume(1, fadeDuration: 0.08)
    }
    
    public func pause() {
        isPlaying = false
        let fadeOutDuration = 0.3
        audioPlayer?.setVolume(0, fadeDuration: fadeOutDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutDuration) {
            self.audioPlayer?.pause()
        }
    }

    public func stop() {
        isPlaying = false
        let fadeOutDuration = 0.1
        audioPlayer?.setVolume(0, fadeDuration: fadeOutDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutDuration) {
            self.audioPlayer?.stop()
            self.audioPlayer?.currentTime = 0
        }
    }

    public func forward() {
        if let player = self.audioPlayer {
            let increase = player.currentTime + 15
            if increase < self.duration {
                player.currentTime = increase
            } else {
                // give the user the chance to hear the end if he wishes
                player.currentTime = duration
            }
        }
    }

    public func rewind() {
        if let player = self.audioPlayer {
            let decrease = player.currentTime - 15.0
            if decrease < 0.0 {
                player.currentTime = 0
            } else {
                player.currentTime -= 15
            }
        }
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if isRepeating  {
            play(sound: currentTrack)
        } else {
            isPlaying = false
        }
    }
}
