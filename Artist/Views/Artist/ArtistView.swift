//
//  ProfileView.swift
//  Artist
//
//  Created by Vladislav Green on 3/9/23.
//

import SwiftUI
import CoreData


struct ArtistView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name, order: .reverse)],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    @AppStorage("defaultArtistName") var defaultArtistName: String?
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    @State private var showingReleases = false
    @State private var showingLogin = false
    @State var scrollOffset = CGFloat.zero
    
    @ObservedObject var audioManager = StreamManager.shared
    
    var body: some View {
        
        // 🛑 СДЕЛАТЬ ПРОВЕРКУ
        if let artist = artists.first {
            
            ZStack {
                
                VStack {
                    HStack {
                        Button(action: {
                            // Пока это просто индикатор
                        }) {
                            Image(systemName: self.audioManager.isPlaying ? "play.fill" : "play")
                                .font(CustomFont.title)
                                .imageScale(.medium)
                        }
                        
                        Spacer()
                        
                        if !isLoggedIn {
                            LoginButton() {
                                showingLogin.toggle()
                            }
                            .sheet(isPresented: $showingLogin) {
                                LoginView()
                            }
                        }
                        
                    }
                    Spacer()
                }
                .zIndex(1)
                .padding(8)
                
                VStack {
                    AvatarImageView(mainImageURL: artists.first?.mainImageURL ?? "")
                        .ignoresSafeArea(edges: .horizontal)
                        .blur(radius: scrollOffset/90)
                        .opacity(90 / scrollOffset)
                    Spacer()
                }
                
                ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                    
                    VStack {
                        ZStack {
                            AvatarImageView(mainImageURL: artists.first?.mainImageURL ?? "")
                                .ignoresSafeArea(edges: .horizontal)
                                .opacity(0)
                            
                            // Невидимая кнопка Play?
                            Button(action: {
                                //                            guard !audioManager.isPlaying else {
                                //                                audioManager.pause()
                                //                                return
                                //                            }
                                //                            if let releases = artists.first?.releases {
                                //                                audioManager.playTopPlaylist(releases: Array(releases))
                                //                            }
                            }) {
                                Image(systemName: "play.circle")
                                    .resizable()
                                    .font(CustomFont.title)
                                    .imageScale(.medium)
                                    .foregroundColor(.red)
                                    .opacity(0)
                            }
                        }
                        
                        VStack {
                            VStack {
                                Text(artists.first?.name ?? "")
                                    .font(CustomFont.title)
                                    .foregroundColor(.white)
                                    .bold()
                                    .padding(4)
                                HStack {
                                    Text(artists.first?.genrePrimary ?? "")
                                        .font(CustomFont.subheading)
                                        .foregroundColor(.white)
                                    //                                Text("\(scrollOffset)")
                                }
                            }
                            .foregroundColor(.textTertiary)
                            .offset(y: -72)
                            .frame(height: 0)
                            
                            VStack {
                                if artists.first != nil {
                                    if let releases: [Release] = Array(artists.first?.releases! ?? []) {
                                        ReleaseRow(releases: releases)
                                        //                                        .environment(\.managedObjectContext, self.viewContext)
                                    }
                                    
                                    let posts: [Post] = Array(artists.first?.posts! ?? []).sorted {
                                        $0.dateCreatedTS > $1.dateCreatedTS
                                    }
                                    if let posts {
                                        PostList(artist: artist, posts: posts, isPreview: true)
                                            .environment(\.managedObjectContext, self.viewContext)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .scrollDisabled(true)
                                    }
                                }
                                Text("2023, Artist App")
                            }
                        }
                        .background(Color(.systemBackground))
                    }
                }
                
                VStack {
                    Spacer()
                    AudioPlayerView()
                }
                .zIndex(1)
            }
            .onChange(of: defaultArtistName ?? "") { value in
                artists.nsPredicate = defaultArtistName?.isEmpty ?? true
                ? nil
                : NSPredicate(format: "name == %@", value)
            }
            .onAppear {
                artists.nsPredicate = defaultArtistName?.isEmpty ?? true
                ? nil
                : NSPredicate(format: "name == %@", defaultArtistName!)
            }
        } else {
            VStack {
                Text("No artists to show".localized)
            }
        }
    }
}


//#if DEBUG
//struct ArtistView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ArtistView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
//#endif
