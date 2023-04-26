//
//  Release.swift
//  Artist
//
//  Created by Vladislav Green on 3/18/23.
//

import SwiftUI


struct ReleaseHome: View {
    
//    var artist: Artist
    var releases: [Release]
    
    var body: some View {
        NavigationView {
            List {
                ZStack{
                    let featuredReleases = releases.filter { $0.isFeatured }
                    Image(featuredReleases[0].imageCoverName ?? "Ono")
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
                    Text(key + "s")
                        .font(CustomFont.heading)
                        .padding(.leading, 16)
                        .padding(.top, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 0) {
                            let releasesTypeSorted = releaseTypes[key]!

                            ForEach(releasesTypeSorted) { release in
                                NavigationLink {
                                    ReleaseDetail(release: release)
                                } label: {
                                    ReleaseItem(release: release)
                                }
                            }
                        }
                    }
                    .frame(height: 140)
                }
                
                
                
//                ForEach(releaseTypes.keys.sorted(), id: \.self) { key in
//                    ReleaseRow(
//                        artist: artist,
//                        releaseType: key,
//                        releasesTypeSorted: releaseTypes[key]!,
//                        isSortedByType: true)
//                }
//                .listRowInsets(EdgeInsets())
            }
            .listStyle(.inset)
            .navigationTitle("Discography")
        }
    }
    
    private func sortReleases(releases: [Release]) -> [String: [Release]] {
        var releaseTypes: [String : [Release]] {
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
