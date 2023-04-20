//
//  Release.swift
//  Artist
//
//  Created by Vladislav Green on 3/18/23.
//

import SwiftUI


struct ReleaseHome: View {
    
//    @EnvironmentObject var artistModelData: ArtistModelData
//    @FetchRequest(sortDescriptors: []) var artists: FetchedResults<Artist>
    @EnvironmentObject var artist: Artist
    
    var body: some View {
        NavigationView {
            List {
                
                ZStack{
                    let allReleases = Array(artist.releases! as Set<Release>)
                    let featuredReleases = allReleases.filter { $0.isFeatured }
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
                
                var releaseTypes = sortReleases(artist: artist)
                
                ForEach(releaseTypes.keys.sorted(), id: \.self) { key in
                    ReleaseRow(releaseType: key, items: releaseTypes[key]!, isSortedByType: true)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.inset)
            .navigationTitle("Discography")
        }
    }
    
    private func sortReleases(artist: Artist) -> [String: [Release]] {
        var releaseTypes: [String: [Release]] {
            Dictionary(
                grouping: Array(artist.releases as! Set),
                by: { $0.type ?? "Unsorted" }
            )
        }
        return releaseTypes
    }
}

//struct ReleaseHome_Previews: PreviewProvider {
//    static var previews: some View {
//        ReleaseHome()
//            .environmentObject(ArtistModelData())
//    }
//}
