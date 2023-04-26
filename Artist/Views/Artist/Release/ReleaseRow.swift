//
//  ReleaseRow.swift
//  Artist
//
//  Created by Vladislav Green on 3/18/23.
//

import SwiftUI

struct ReleaseRow: View {
    
//    var artist: Artist
    
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        sortDescriptors: [SortDescriptor(\.dateReleasedTS, order: .reverse)],
////        predicate: NSPredicate(format: "ofArtist = %@", artist),
//        animation: .default)
//    private var releases: FetchedResults<Release>
    
    var releases: [Release]
    
    @State var showingReleases = false
    @State private var selectedRelease: Release? = nil
    
    var body: some View {
        
        VStack(alignment: .leading) {
                
            FieldSeparator(title: "Discography")
            .onTapGesture {
                showingReleases.toggle()
            }
            .sheet(isPresented: $showingReleases) {
                ReleaseHome(releases: Array(releases))
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
//         НЕ ПОЛУЧАЕТ ПРЕДИКАТА ПРИ ЗАПУСКЕ ПРИЛОЖЕНИЯ
//        .onAppear {
//            print("🆔 onAppear Release артист: \(artist.name)")
//            releases.nsPredicate = NSPredicate(format: "ofArtist == %@", artist)
//        }
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
