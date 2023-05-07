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
                    ImageDiskOrURL(imageURL: artists.first?.mainImageURL ?? "")
                        .ignoresSafeArea(edges: .horizontal)
                        .blur(radius: scrollOffset/90)
                        .opacity(90 / scrollOffset)
                    Spacer()
                }
                
                ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                    
                    VStack {
                        ZStack {
                            ImageDiskOrURL(imageURL: artists.first?.mainImageURL ?? "")
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


#if DEBUG
struct ArtistView_Previews: PreviewProvider {

    static var previews: some View {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let track1 = Track(context: viewContext)
        track1.favoritedCount = 12
        track1.id = UUID(uuidString: "E07ABFD8-429B-6A6A-AEDB-EE4C9E9A7C70")!
        track1.number = 1
        track1.trackName = "trackName"
        track1.trackURL = "https://drive.google.com/uc?export=open&id=1dzee5B6xD89AKkklvRnJ2Sz7LNNzTap4"
        
        let release1 = Release(context: viewContext)
        release1.dateEditedTS = Date(timeIntervalSince1970: 1672531200000)
        release1.dateReleasedTS = Date(timeIntervalSince1970: 1672531200000)
        release1.id = UUID(uuidString: "E07ABFD8-429B-4A5A-AEDB-EE4C9E9A7C94")!
        release1.imageCoverName = "imageCoverName"
        release1.imageCoverURL = "https://drive.google.com/uc?export=open&id=1gmSLscIWQoR0-DEBdWIf3fv6LKt38AsJ"
        release1.isFeatured = true
        release1.labelName = "labelName"
        release1.name = "Preview Release"
        release1.type = "Single"
        release1.tracks = [track1]
        
        let post1 = Post(context: viewContext)
        post1.dateCreatedTS = Date(timeIntervalSince1970: 1672531200000)
        post1.dateEditedTS = Date(timeIntervalSince1970: 1672531200000)
        post1.id = UUID(uuidString: "E07ABFD9-429B-4A5A-AEDB-EE4C9E9A7C94")!
        post1.imageName = "imageName"
        post1.imageURL = "imageURL"
        post1.isFlagged = true
        post1.likeCount = 321
        post1.text = "textENtextENtextENtextENtextENtextENtextENtextENtextENtextENtextENtextEN"
        post1.title = "titleEN"
        post1.viewCount = 87
        
        let artist1 = Artist(context: viewContext)
        artist1.city = "city"
        artist1.countFollowers = 654
        artist1.countLikes = 54
        artist1.country = "country"
        artist1.dateEditedTS = Date(timeIntervalSince1970: 1672531200000)
        artist1.dateRegisteredTS = Date(timeIntervalSince1970: 1672531200000)
        artist1.descriptionFull = "descriptionFulldescriptionFulldescriptionFulldescriptionFulldescriptionFull"
        artist1.descriptionShort = "descriptionShort"
        artist1.genrePrimary = "genrePrimary"
        artist1.genreSecondary = "genreSecondary"
        artist1.id = UUID()
        artist1.isConfirmed = true
        artist1.isPrimary = true
        artist1.mainImageName = "PreviewTrio"
        artist1.mainImageURL = "https://drive.google.com/uc?export=open&id=1M893MdmN3phicZRKt8Npj6-R0r4HMYVk"
        artist1.name = "Artist Name From Persistance"
        artist1.releases = [release1]
        artist1.posts = [post1]

        try? viewContext.save()
        
        return ArtistView()
            .environment(\.managedObjectContext, viewContext)
    }
}
#endif
