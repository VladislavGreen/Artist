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
    
    @State private var showingReleases = false
    @State private var showingProfile = false
    @State var scrollOffset = CGFloat.zero
    
    @ObservedObject var audioManager = StreamManager.shared

    
    var body: some View {
        
        if artists.count != 0 {
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

                        ProfileButton() {
                            showingProfile.toggle()
                        }
                        .sheet(isPresented: $showingProfile) {
                            ProfileHost()
                        }

                    }
                    Spacer()
                }
                .zIndex(1)
                .padding(8)
                
                VStack {
                    
                    AvatarImageView(imageName: artists.first?.mainImageName ?? "person")
                        .ignoresSafeArea(edges: .horizontal)
                        .blur(radius: scrollOffset/90)
                        .opacity(90 / scrollOffset)
                     Spacer()
                }
              
                ObservableScrollView(scrollOffset: $scrollOffset) { proxy in

                    VStack {

                        ZStack {
                            AvatarImageView(imageName: artists.first?.mainImageName ?? "person")
                                .ignoresSafeArea(edges: .horizontal)
                                .opacity(0)
                                .onAppear {
                                    getDefaultArtist()
                                }
                            
                            // Невидимая кнопка Play
                            Button(action: {
                                guard !audioManager.isPlaying else {
                                    audioManager.pause()
                                    return
                                }
                                if let releases = artists.first?.releases {
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
                                Text((artists.first?.name ?? "no artist") + "Rockstar Rockstarovitch ")
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

                                if let releases = artists.first?.releases {
                                    ReleaseRow(
//                                        releaseType: "Any",
                                        releases: Array(releases as Set<Release>).sorted {
                                            $0.dateReleasedTS > $1.dateReleasedTS
                                        },
                                        isSortedByType: false
                                    )
                                    .environment(\.managedObjectContext, self.viewContext)
                                } else {
                                    Text("Пока релизов нет")
                                }

                                PostList (isPreview: true, posts: Array(artists.first?.posts ?? []))
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
            .onChange(of: defaultArtistName ?? "") { value in
                artists.nsPredicate = defaultArtistName?.isEmpty ?? true
                ? nil
                : NSPredicate(format: "name == %@", value)
            }
        } else {
            Text("Пока ничего не загружено. Можно придумать какую-нибудь картинку на этот случай.")
        }
    }
    
    private func getDefaultArtist() {
        if artists.count  != 0 {
            for artist in artists {
                    defaultArtistName = artist.name
                    break
            }
        } else {
            print("artists.count = 0 ")
        }
    }
}


#if DEBUG
//struct ArtistView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ArtistView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
#endif
