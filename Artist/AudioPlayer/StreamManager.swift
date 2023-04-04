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
    
    public var folderName: String?
    
    
//    @State var finish = false
    
    @State var isDownloaded = false
    @State var disableDownload = false
    @State var showingAlert = false
    
    @State var isDownloading = false
    
    
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
    
    private func prepareToPlay(url: String, soundExtension: String) {
        
        guard InternetConnectionManager.isConnectedToNetwork() else {
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
        
        let playerItem : AVPlayerItem = AVPlayerItem(url: url!)
            
        let player = AVPlayer(playerItem: playerItem)
        player.automaticallyWaitsToMinimizeStalling = false
        
        self.streamPlayer = player
        

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]

        duration = (self.streamPlayer?.currentItem?.asset.duration.seconds) ?? 0.1    // used when forwarding
        formattedDuration = formatter.string(from: TimeInterval(duration))!

        print(formattedDuration)
        print("currentItem?.duration.seconds: \(self.streamPlayer?.currentItem?.asset.duration.seconds)")
        print("currentTime().seconds: \(self.streamPlayer?.currentTime().seconds)")
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let player = self.streamPlayer {
//                if !self.isPlaying {
//                    self.isPlaying = false
//                }
                self.progress = CGFloat((self.streamPlayer?.currentTime().seconds ?? 0.0)/(self.duration))
                self.formattedProgress = formatter.string(from: TimeInterval(player.currentTime().seconds))!
            }
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
        print(currentTrack?.trackName)
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
//        self.streamPlayer?.actionAtItemEnd
        
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
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // нужно ли что-то для streamPlayer ??
        // self.streamPlayer?.actionAtItemEnd ???

    }
    
    public func playTopPlaylist(releases: [Release]) {
        // всё ещё висит вопрос с AVQueuePlayer
        
        var topPlaylist: [Track] = []
        
        releases.forEach { release in
            let tracks = release.tracks
            tracks.forEach { track in
                topPlaylist.append(track)
            }
        }
        
        topPlaylist = topPlaylist.sorted { $0.favoritedCount > $1.favoritedCount}
        playPlaylist(tracks: topPlaylist)
        
        print("playTopPlaylist")
    }
    
    
    public func downloadTrack (track: Track) {
        let urlString = track.trackURL
                                
        let encodedSoundString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        
        self.downloadAndSaveAudioFile(encodedSoundString!) { (url) in
            self.isDownloaded = true
            self.disableDownload = true
        }
    }
    
    
    private func downloadAndSaveAudioFile(_ audioFile: String, completion: @escaping (String) -> Void) {
                
        self.isDownloading.toggle()
        
        //Create directory if not present
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectory = paths.first! as NSString
        let soundDirPathString = documentDirectory.appendingPathComponent(folderName ?? "Default Folder")
        
        do {
            try FileManager.default.createDirectory(atPath: soundDirPathString, withIntermediateDirectories: true, attributes:nil)
            print("directory created at \(soundDirPathString)")
        } catch let error as NSError {
            print("error while creating dir : \(error.localizedDescription)");
        }
        
        if let audioUrl = URL(string: audioFile) {
            // create your document folder url
            let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first! as URL
            let documentsFolderUrl = documentsUrl.appendingPathComponent(folderName ?? "Default Folder")
            // your destination file url
            let destinationUrl = documentsFolderUrl.appendingPathComponent(audioUrl.lastPathComponent)
            
            print(destinationUrl)
            // check if it exists before downloading it
            if FileManager().fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                self.isDownloading.toggle()
            } else {
                //  if the file doesn't exist
                //  just download the data from your url
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                    if let myAudioDataFromUrl = try? Data(contentsOf: audioUrl){
                        // after downloading your data you need to save it to your destination url
                        if (try? myAudioDataFromUrl.write(to: destinationUrl, options: [.atomic])) != nil {
                            print("file saved")
                            completion(destinationUrl.absoluteString)
                            self.isDownloading.toggle()
                        } else {
                            print("error saving file")
                            completion("")
                        }
                    }
                })
            }
        }
    }
}

