//
//  ReleaseRow.swift
//  Artist
//
//  Created by Vladislav Green on 3/18/23.
//

import SwiftUI

struct ReleaseRow: View {
    
    var releaseType: String = "Any"
    var releases: [Release]
    var isSortedByType: Bool = false
    
    @State var showingReleases = false
    @State private var selectedRelease: Release? = nil

    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if isSortedByType {
                
                Text(releaseType + "s")
                    .font(CustomFont.heading)
                    .padding(.leading, 16)
                    .padding(.top, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(releases) { release in
                            NavigationLink {
                                ReleaseDetail(release: release)
                            } label: {
                                ReleaseItem(release: release)
                            }
                        }
                    }
                }
                .frame(height: 140)
                
            } else {
                
                FieldSeparator(title: "Discography")
                .onTapGesture {
                    showingReleases.toggle()
                }
                .sheet(isPresented: $showingReleases) {
                    ReleaseHome(releases: releases)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(releases) { release in
                            ReleaseItem(release: release)
                            .onTapGesture {
                                self.selectedRelease = release
                            }
                        }
                    }
                    
                }
                .frame(height: 124)
                .sheet(item: $selectedRelease) { release in
                    ReleaseDetail(release: release)
                }
            }
        }
    }
}

//#if DEBUG
//struct ReleaseRow_Previews: PreviewProvider {
//    static var artists = ArtistModelData().artists
//    
//    static var previews: some View {
//        ReleaseRow(
//            releaseType: artists[0].releases[0].type.rawValue,
//            items: Array(artists[0].releases.prefix(3)), isSortedByType: true)
//    }
//}
//#endif
