//
//  ProfileView.swift
//  Artist
//
//  Created by Vladislav Green on 3/9/23.
//

import SwiftUI


struct ArtistView: View {
    
    @State private var showingReleases = false
    @State private var showingProfile = false
    @State var scrollOffset = CGFloat.zero
    
    @ObservedObject var audioManager = AudioManager.shared
    
    
    let artist = ArtistModelData().artists[0]
    
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
                    ProfileButton() {
                        showingProfile.toggle()
                    }
                    .sheet(isPresented: $showingProfile) {
                        ProfileHost()
//                            .environmentObject(artistModelData)
                    }
                    
                }
                Spacer()
            }
            .zIndex(1)
            .padding(8)
            
            
            
            VStack {
                AvatarImageView(image: artist.mainImage)
                 .ignoresSafeArea(edges: .horizontal)
                 .blur(radius: scrollOffset/90)
                 .opacity(90 / scrollOffset)

                 Spacer()
            }
          
            ObservableScrollView(scrollOffset: $scrollOffset) { proxy in

                VStack {

                    AvatarImageView(image: artist.mainImage)
                        .ignoresSafeArea(edges: .horizontal)
                        .opacity(0)

                    VStack {

                        VStack {
                            Text(artist.name + "Rockstar Rockstarovitch ")
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
                                                        
                            ReleaseRow(
                                releaseType: "Album",
                                items: artist.releases,
                                isSortedByType: false
                            )
                            
                            PostList(isPreview: true)
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

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistView()
            .environmentObject(ArtistModelData())
    }
}
