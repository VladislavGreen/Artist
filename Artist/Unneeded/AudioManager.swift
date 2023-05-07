//
//  AudioPlayer.swift
//  Artist
//
//  Created by Vladislav Green on 3/23/23.
//  https://laurentbrusa.hashnode.dev/creating-an-accessible-audio-player-in-swiftui-part-2


// Оказалось, что AVAudioPlayer не подходит для стриминга, придётся написать ещё с AVQueuePlayer (или AVPlayer)
// Этот можно использовать для скачанных треков, но пока не используем

//import Foundation
//import AVKit
//
//
//final class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
//    
//    static let shared = AudioManager()
//    
//    @Published public var isPlaying: Bool = false
//    @Published public var isPaused: Bool = false
//    @Published public var isRepeating = false
//    @Published public var progress: CGFloat = 0.0
//    @Published public var duration: Double = 0.0
//    @Published public var formattedDuration: String = ""
//    @Published public var formattedProgress: String = "00:00"
//    @Published public var currentTrack: Track?
//    
//    @Published var audioPlayer: AVAudioPlayer?
//    
//    @Published public var isPlaylist = false
//    @Published public var playlist: [Track] = []
//    private var playlistTracksCounter = 0
//    
//    public var volume: Double = 1 {
//        didSet {
//            audioPlayer?.volume = Float(volume)
//        }
//    }
//    
//    
//    private func prepareToPlay(sound: String, soundExtension: String) {
//        guard let url = Bundle.main.url(forResource: sound, withExtension: soundExtension) else {
//            print("Failed to find \(sound) in bundle 1.")
//            return
//        }
//
//        guard let player = try? AVAudioPlayer(contentsOf: url) else {
//            print("Failed to load \(sound) from bundle.")
//            return
//        }
//        self.audioPlayer = player
//        self.audioPlayer?.prepareToPlay()
//
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.minute, .second]
//        formatter.unitsStyle = .positional
//        formatter.zeroFormattingBehavior = [.pad]
//
//        formattedDuration = formatter.string(from: TimeInterval(self.audioPlayer?.duration ?? 0.0))!
//        duration = self.audioPlayer?.duration ?? 0.0    // used when forwarding
//
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//            if let player = self.audioPlayer {
//                if !player.isPlaying {
//                    self.isPlaying = false
//                }
//                self.progress = CGFloat(player.currentTime / player.duration)
//                self.formattedProgress = formatter.string(from: TimeInterval(player.currentTime))!
//            }
//        }
//        audioPlayer?.delegate = self
//    }
//    
//    
//    public func play(track: Track) {
//        
//        if !isPaused {
//            currentTrack = track
//        }
//        let soundExtension = ".mp3"
//        prepareToPlay(sound: track.trackName, soundExtension: soundExtension)
//        isPlaying = true
//        isPaused = false
//        audioPlayer?.setVolume((0), fadeDuration: 0.1)
//        audioPlayer?.play()
//        audioPlayer?.setVolume(1, fadeDuration: 0.08)
//        
//        print("play")
//        print(currentTrack?.trackName)
//    }
//    
//    public func continuePlayback() {
//        audioPlayer?.setVolume(1, fadeDuration: 0.08)
//        audioPlayer?.play()
//        isPlaying = true
//        isPaused = false
//        
//        print("continuing playback")
//    }
//    
//    public func playPlaylist(tracks: [Track]) {
//        playlist = tracks
//        isPlaylist = true
//        play(track: playlist[playlistTracksCounter])
//        
//        print("playPlaylist")
//    }
//    
//    public func pause() {
//        isPlaying = false
//        isPaused = true
//        
//        let fadeOutDuration = 0.3
//        audioPlayer?.setVolume(0, fadeDuration: fadeOutDuration)
//        DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutDuration) {
//            self.audioPlayer?.pause()
//        }
//        
//        print("pause")
//    }
//
//    public func stop() {
//        isPlaying = false
//        isPaused = false
//        playlistTracksCounter = 0
//        let fadeOutDuration = 0.1
//        audioPlayer?.setVolume(0, fadeDuration: fadeOutDuration)
//        DispatchQueue.main.asyncAfter(deadline: .now() + fadeOutDuration) {
//            self.audioPlayer?.stop()
//            self.audioPlayer?.currentTime = 0
//        }
//        
//        print("Stop")
//    }
//
//    public func forward() {
//        if let player = self.audioPlayer {
//            let increase = player.currentTime + 15
//            if increase < self.duration {
//                player.currentTime = increase
//            } else {
//                // give the user the chance to hear the end if he wishes
//                player.currentTime = duration
//            }
//        }
//    }
//
//    public func rewind() {
//        if let player = self.audioPlayer {
//            let decrease = player.currentTime - 15.0
//            if decrease < 0.0 {
//                player.currentTime = 0
//            } else {
//                player.currentTime -= 15
//            }
//        }
//    }
//    
//    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        if isRepeating  {
//            if let currentTrack {
//                play(track: currentTrack)
//            } else {
//                stop()
//            }
//        }
//        if isPlaylist {
//            playlistTracksCounter += 1
//            
//            guard playlist.count > playlistTracksCounter else {
//                isPlaying = false
//                playlistTracksCounter = 0
//                isPlaylist = false
//                return
//            }
//            play(track: playlist[playlistTracksCounter])
//        }
//        else {
//            isPlaying = false
//            playlistTracksCounter = 0
//            isPlaylist = false
//        }
//        
//        print("audioPlayerDidFinishPlaying")
//    }
//}
//
//
//extension AudioManager {
//    public func playTopPlaylist(releases: [Release]) {
//        var topPlaylist: [Track] = []
//        
//        releases.forEach { release in
//            let tracks = release.tracks
//            tracks.forEach { track in
//                topPlaylist.append(track)
//            }
//        }
//        
//        topPlaylist = topPlaylist.sorted { $0.favoritedCount > $1.favoritedCount}
//        playPlaylist(tracks: topPlaylist)
//        
//        print("playTopPlaylist")
//    }
//}
