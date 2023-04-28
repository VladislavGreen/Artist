//
//  ReleaseDetail.swift
//  Artist
//
//  Created by Vladislav Green on 3/20/23.
//

import SwiftUI

struct ReleaseDetail: View {
    
    @ObservedObject var audioManager = StreamManager.shared
    
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
                    if let imageURL = release.imageCoverURL {
                        let downloadManager = DownloadManager()
                        if downloadManager.getImageFromDefaults(imageURLString: imageURL) == nil {
                            AsyncImage(url: URL(string: imageURL)) { phase in
                                switch phase {
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                case .success(let image):
                                    image .resizable()
                                default:
                                    ProgressView()
                                }
                            }
                            .cornerRadius(12)
                        } else {
                            downloadManager.getImageFromDefaults(imageURLString: imageURL)!
                                .resizable()
                                .cornerRadius(0)
                        }
                    }
                }
                
                Button(action: {
                    guard !audioManager.isPlaying else {
                        audioManager.pause()
                        return
                    }
                    audioManager.playPlaylist(tracks: Array(release.tracks as! Set))
                }) {
                    Image(systemName: "play.fill")
                        .font(CustomFont.title)
                        .imageScale(.medium)
                }
                .zIndex(1)
            }
            
            List {
                ForEach(
                    Array(release.tracks as Set<Track>).sorted {
                        $0.number < $1.number
                    }
                ) { track in
                    
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
    
    // Формируем плейлист из текущего трека и остальных осташихся и проигрываем
    
    private func trackPlayButtonAction(track: Track) {
        
        var playlist: [Track] = []
        playlist.append(track)
        // Ждём CoreData, что-бы найти остальные треки? upd: забыл идею :-)
        
        if audioManager.currentTrack?.id == track.id,
           audioManager.isPlaying {
                audioManager.pause()
        }
        if audioManager.currentTrack?.id != track.id,
           audioManager.isPlaying {
                audioManager.playPlaylist(tracks: playlist)
        }
        if !audioManager.isPlaying  {
                audioManager.playPlaylist(tracks: playlist)
        }
    }
    
    
    private func trackPlayButtonLabel(track: Track) -> String {
        if audioManager.currentTrack?.id == track.id,
           audioManager.isPlaying {
            return "pause.circle"
        } else {
            return "play"
        }
    }
    
}


//#if DEBUG
//struct ReleaseDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ReleaseDetail(release: ArtistModelData().artists[0].releases[1])
//            .environmentObject(ArtistModelData())
//    }
//}
//#endif
