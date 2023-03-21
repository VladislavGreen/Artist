//
//  ProfileView.swift
//  Artist
//
//  Created by Vladislav Green on 3/9/23.
//

import SwiftUI


struct ProfileView: View {
    
    @State private var showingReleases = false
    @State var scrollOffset = CGFloat.zero
    
    let artist = ArtistModelData().artists[0]
    
    var body: some View {
        
        ZStack {
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
                                .padding(4)
                            HStack {
                                Text("Main Genre")
                                    .font(CustomFont.subheading)
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
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(ArtistModelData())
    }
}
