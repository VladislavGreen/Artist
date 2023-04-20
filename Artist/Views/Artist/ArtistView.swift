//
//  ProfileView.swift
//  Artist
//
//  Created by Vladislav Green on 3/9/23.
//

import SwiftUI
import CoreData


struct ArtistView: View {
    
    @AppStorage("defaultArtistName") var defaultArtistName: String?
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name, order: .reverse)],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    var artistIndex: Int = 0
    
    @State private var showingReleases = false
    @State private var showingProfile = false
    @State var scrollOffset = CGFloat.zero
    
    @ObservedObject var audioManager = StreamManager.shared

    
    var body: some View {
        
        ZStack {
            
//            VStack {
//                HStack {
//                    Button(action: {
//                        // Пока это просто индикатор
//                    }) {
//                        Image(systemName: self.audioManager.isPlaying ? "play.fill" : "play")
//                            .font(CustomFont.title)
//                            .imageScale(.medium)
//                    }
//
//                    Spacer()
//
//                    ProfileButton() {
//                        showingProfile.toggle()
//                    }
//                    .sheet(isPresented: $showingProfile) {
//                        ProfileHost()
//                    }
//
//                }
//                Spacer()
//            }
//            .zIndex(1)
//            .padding(8)
            
            VStack {
                
                if artists.count != 0 {
                    AvatarImageView(imageName: artists[artistIndex].mainImageName ?? "person")
                        .ignoresSafeArea(edges: .horizontal)
                        .blur(radius: scrollOffset/90)
                        .opacity(90 / scrollOffset)
                } else {
                    Text("Пока ничего не загружено")
                }
                 Spacer()
            }
          
//            ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
//
//                VStack {
//
//                    ZStack {
//                        AvatarImageView(imageName: artists[artistIndex].mainImageName ?? "person")
//                            .ignoresSafeArea(edges: .horizontal)
//                            .opacity(0)
//
//                        Button(action: {
//                            guard !audioManager.isPlaying else {
//                                audioManager.pause()
//                                return
//                            }
//                            audioManager.playTopPlaylist(releases: Array(artists[artistIndex].releases)
//                            )
//                        }) {
//                            Image(systemName: "play.circle")
//                                .resizable()
//                                .font(CustomFont.title)
//                                .imageScale(.medium)
//                                .foregroundColor(.red)
//                                .opacity(0)
//                        }
//
//                    }
//
//                    VStack {
//
//                        VStack {
//                            Text((artists[artistIndex].name ?? "no artist") + "Rockstar Rockstarovitch ")
//                                .font(CustomFont.title)
//                                .foregroundColor(.white)
//                                .bold()
//                                .padding(4)
//                            HStack {
//                                Text("Main Genre")
//                                    .font(CustomFont.subheading)
//                                    .foregroundColor(.white)
//                                Text("\(scrollOffset)")
//                            }
//                        }
//                        .foregroundColor(.textTertiary)
//                        .offset(y: -72)
//                        .frame(height: 0)
//
//                        VStack {
//
//                            ReleaseRow(
//                                releaseType: "Album",
//                                items: Array(artists[artistIndex].releases),
//                                isSortedByType: false
//                            )
//
//                            PostList(
//                                isPreview: true
//                            )
//                                .frame(minWidth: 0, maxWidth: .infinity)
//                                .scrollDisabled(true)
//
//                            Text("2023, Artist App")
//                        }
//                    }
//                    .background(Color(.systemBackground))
//
//                }
//            }
//
//            VStack {
//                Spacer()
//
//                AudioPlayerView()
//            }
//            .zIndex(1)
        }
    }
}

//struct ArtistView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ArtistView()
//            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
//
//    }
//
//}
