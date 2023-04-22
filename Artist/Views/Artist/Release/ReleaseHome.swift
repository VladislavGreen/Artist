//
//  Release.swift
//  Artist
//
//  Created by Vladislav Green on 3/18/23.
//

import SwiftUI


struct ReleaseHome: View {
    
    var releases: [Release]
    
    var body: some View {
        NavigationView {
            List {
                
                ZStack{
                    let featuredReleases = releases.filter { $0.isFeatured }
                    Image(featuredReleases[0].imageCoverName ?? "person")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .listRowInsets(EdgeInsets())
                    
                    VStack {
                        
                        Spacer()
                        
                        HStack {
                            
                            Text("Featured")
                                .font(CustomFont.heading)
                                .colorInvert()
                                .padding(.leading, 16)
                            Spacer()
                        }
                        .padding(.bottom, 16)
                    }
                        
                }
                .listRowInsets(EdgeInsets())
                
                let releaseTypes = sortReleases(releases: releases)
                
                ForEach(releaseTypes.keys.sorted(), id: \.self) { key in
                    ReleaseRow(releaseType: key, releases: releaseTypes[key]!, isSortedByType: true)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.inset)
            .navigationTitle("Discography")
        }
    }
    
    private func sortReleases(releases: [Release]) -> [String: [Release]] {
        var releaseTypes: [String: [Release]] {
            Dictionary(
                grouping: releases,
                by: { $0.type }
            )
        }
        return releaseTypes
    }
}


//#if DEBUG
//struct ReleaseHome_Previews: PreviewProvider {
//    static var previews: some View {
//        ReleaseHome()
//            .environmentObject(ArtistModelData())
//    }
//}
//#endif
