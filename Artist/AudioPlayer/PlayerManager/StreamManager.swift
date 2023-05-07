//
//  StreamManager.swift
//  Artist
//
//  Created by Vladislav Green on 4/4/23.
//  https://github.com/amrezo/SereneAudioPlayer/blob/master/Sources/SereneAudioPlayer/Players/SereneAudioStreamPlayer.swift

import SwiftUI
import AVFoundation
import MediaPlayer


final class StreamManager: NSObject, ObservableObject {
    
    static let shared = StreamManager()
    
//    public var folderName: String?
//    
//    
////    @State var finish = false
//    
//    @State var isDownloaded = false
//    @State var disableDownload = false
    @State var showingAlert = false
//    
//    @State var isDownloading = false
    
    @Published public var isPlaying: Bool = false
    @Published public var isPaused: Bool = false
    @Published public var isRepeating = false
    @Published public var progress: CGFloat = 0.0
    @Published public var duration: Double = 0.0
    @Published public var formattedDuration: String = ""
    @Published public var formattedProgress: String = "00:00"
    @Published public var currentTrack: Track?
    
    @Published var streamPlayer: AVPlayer?
    
    @Published public var isPlaylist = false
    @Published public var playlist: [Track] = []
    private var playlistTracksCounter = 0
    
    public var volume: Double = 1 {
        didSet {
            streamPlayer?.volume = Float(volume)
        }
    }
    
    private func prepareToPlay(url: String, soundExtension: String)  {
        
        guard InternetConnectionChecker.isConnectedToNetwork() else {
            print("Internet connection FAILED")
            showingAlert = true
            return
        }
        print("Internet connection OK")
        
        
        guard let encodedSoundString = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            print("Failed to find \(url) 1.")
            return
        }
        let url = URL(string: encodedSoundString)
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        
        // 🛑 не забыть удалить observer или в deinit
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.playerDidFinishPlaying(sender:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem
        )

        
        let player = AVPlayer(playerItem: playerItem)
        player.automaticallyWaitsToMinimizeStalling = false
        
        self.streamPlayer = player
        
        Task {
            await getDuration()
        }
    }
    
    private func getDuration() async {
        do {
            let itemDuration = try await self.streamPlayer?.currentItem?.asset.load(.duration).seconds ?? 0.1
            await MainActor.run {
                self.duration = itemDuration
                formattedDuration = formatterMinSec().string(from: TimeInterval(duration))!
                
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    if let player = self.streamPlayer {
                        self.progress = CGFloat((self.streamPlayer?.currentTime().seconds ?? 0.0)/(self.duration))
                        self.formattedProgress = self.formatterMinSec().string(from: TimeInterval(player.currentTime().seconds))!
                    }
                }
            }
        } catch {
            print(error)
        }
    }

    
    public func play(track: Track) {
            
        if !isPaused {
            currentTrack = track
        }
        
        let soundExtension = ".mp3"
        prepareToPlay(url: track.trackURL, soundExtension: soundExtension)
        
        isPlaying = true
        isPaused = false
        
        streamPlayer?.play()
        
        print("play")
    }
    
    public func continuePlayback() {
        self.streamPlayer?.play()
        isPlaying = true
        isPaused = false
    }
    
    public func playPlaylist(tracks: [Track]) {
        playlist = tracks
        isPlaylist = true
        play(track: playlist[playlistTracksCounter])
        
        print("playPlaylist")
    }
    
    public func pause() {
        self.streamPlayer?.pause()
        isPlaying = false
        isPaused = true
    }
    
    public func stop() {
        self.streamPlayer?.pause()
        self.streamPlayer?.seek(to: .zero)
        isPlaying = false
        isPaused = false
    }
    
    public func forward() {
        if let player = self.streamPlayer {
            let increase = player.currentTime() + CMTimeMakeWithSeconds(15, preferredTimescale: 1)
            guard player.currentItem != nil else {
                return
            }
            if increase < player.currentItem!.duration {
                player.seek(to: increase)
            } else {
                player.seek(to: .zero)
            }
        }
    }
    
    public func rewind() {
        if let player = self.streamPlayer {
            let decrease = player.currentTime() - CMTimeMakeWithSeconds(15, preferredTimescale: 1)
            if decrease < CMTimeMakeWithSeconds(0, preferredTimescale: 1) {
                player.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: 1))
            } else {
                player.seek(to: decrease)
            }
        }
    }
    
    
    public func playTopPlaylist(releases: [Release]) {
        // всё ещё висит вопрос с AVQueuePlayer
        
        var topPlaylist: [Track] = []
        
        releases.forEach { release in
            let tracks = Array(release.tracks as Set<Track>)
            tracks.forEach { track in
                topPlaylist.append(track)
            }
        }
        
        topPlaylist = topPlaylist.sorted { $0.favoritedCount > $1.favoritedCount}
        playPlaylist(tracks: topPlaylist)
        
        print("playTopPlaylist")
    }
    
    
    @objc
    private func playerDidFinishPlaying(sender: Notification) {
        print("⭕️ трек закончился")
        self.stop()
    }
    
    
    private func formatterMinSec() -> DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }
}

