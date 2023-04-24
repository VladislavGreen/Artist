//
//  ProfileView.swift
//  Artist
//
//  Created by Vladislav Green on 3/9/23.
//

import SwiftUI
import CoreData


struct ArtistView: View {
    
    var artist: Artist
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showingReleases = false
    @State private var showingLogin = false
    @State var scrollOffset = CGFloat.zero
    
    @ObservedObject var audioManager = StreamManager.shared
    
    var body: some View {
        
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

                    LoginButton() {
                        showingLogin.toggle()
                    }
                    .sheet(isPresented: $showingLogin) {
                        LoginView()
                    }

                }
                Spacer()
            }
            .zIndex(1)
            .padding(8)
            
            VStack {
                
                AvatarImageView(imageName: artist.mainImageName ?? "person")
                    .ignoresSafeArea(edges: .horizontal)
                    .blur(radius: scrollOffset/90)
                    .opacity(90 / scrollOffset)
                 Spacer()
            }
          
            ObservableScrollView(scrollOffset: $scrollOffset) { proxy in

                VStack {

                    ZStack {
                        AvatarImageView(imageName: artist.mainImageName ?? "person")
                            .ignoresSafeArea(edges: .horizontal)
                            .opacity(0)
                        
                        // Невидимая кнопка Play
                        Button(action: {
                            guard !audioManager.isPlaying else {
                                audioManager.pause()
                                return
                            }
                            if let releases = artist.releases {
                                audioManager.playTopPlaylist(releases: Array(releases))
                            }
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
                            Text((artist.name) + "Rockstar Rockstarovitch ")
                                .font(CustomFont.title)
                                .foregroundColor(.white)
                                .bold()
                                .padding(4)
                            HStack {
                                Text("Main Genre")
                                    .font(CustomFont.subheading)
                                    .foregroundColor(.white)
                                Text("\(scrollOffset)")
                            }
                        }
                        .foregroundColor(.textTertiary)
                        .offset(y: -72)
                        .frame(height: 0)

                        VStack {

                            if let releases = artist.releases {
                                ReleaseRow(
                                    releases: Array(releases as Set<Release>).sorted {
                                        $0.dateReleasedTS > $1.dateReleasedTS
                                    },
                                    isSortedByType: false
                                )
                                .environment(\.managedObjectContext, self.viewContext)
                            } else {
                                Text("Пока релизов нет")
                            }

                            PostList (
                                isPreview: true,
                                posts: Array(artist.posts ?? []).sorted {
                                    $0.dateCreatedTS > $1.dateCreatedTS
                                }
                            )
                            .environment(\.managedObjectContext, self.viewContext)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .scrollDisabled(true)

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
