//
//  StatsView.swift
//  Artist
//
//  Created by Vladislav Green on 3/10/23.
//

import SwiftUI
import Charts
import Foundation


struct StatsView: View {
    
//    var artist: Artist
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name, order: .reverse)],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    @AppStorage("defaultArtistName") var defaultArtistName: String?
    
    @State var releasesData: [ReleaseTotalFavorited] = []
    @State var tracksData: [TrackTotalFavorited] = []
    @State var moreThenFiveTracks: Bool = false
    @State var postsData: [PostViewsLikes] = []
    @State var moreThenFivePosts: Bool = false
    
    var body: some View {
        let artist = artists.first!
        
        ScrollView {
            
            Text("Ого! У \(artist.name) уже \(artist.countFollowers) слушателей")
                .foregroundColor(.accentColor)
                .padding(.bottom, 16)
            
            VStack {
                Text("Количество прослушиваний:")
                Chart(releasesData) {
                    BarMark(
                        x: .value("Plays", $0.amountFavoritedTracks),
                        y: .value("Name", $0.name)
                    )
                }
                .foregroundColor(.red)
            }
            .frame(height: 200)
            
            VStack {
                Text(moreThenFiveTracks ? "Пять самых популярных треков:" : "Популярные треки:")
                    
                Chart(moreThenFiveTracks ? tracksData[0...4] : tracksData[0..<tracksData.count]) {
                    BarMark(
                        x: .value("Plays", $0.favorited),
                        y: .value("Name", $0.name)
                    )
                }
                .foregroundColor(.accentColor)
            }
            .frame(height: 240)
            
            VStack {
                Text(moreThenFivePosts ? "Пять самых популярных записей:" : "Популярные записи:")
                    
                Chart(moreThenFivePosts ? postsData[0...4] : postsData[0..<postsData.count]) {
                    BarMark(
                        x: .value("Views", $0.value),
                        y: .value("Name", $0.text)
                    )
                    .foregroundStyle(by: .value("Category", $0.category))
                    .position(by: .value("Catagory", $0.category))
                }
            }
            .frame(height: 240)
            
        }
        .padding(16)
        .onAppear {
            print("🆔 onAppear StatsView: Дефолтный артист: \(defaultArtistName)")
            artists.nsPredicate = defaultArtistName?.isEmpty ?? true
            ? nil
            : NSPredicate(format: "name == %@", defaultArtistName!)
            
            getReleasesStats(artist: artist)
            getPostsStats(artist: artist)
        }
//        .onChange(of: defaultArtistName ?? "") { value in
//            print("🆔 onChange StatsView: Дефолтный артист: \(defaultArtistName)")
//            artists.nsPredicate = defaultArtistName?.isEmpty ?? true
//            ? nil
//            : NSPredicate(format: "name == %@", value)
//        }
    }
    
    // Получение статистики записей в ленте новостей (Posts)
    private func getPostsStats(artist: Artist) {
        guard let postsSet = artist.posts else { return }
        let posts = Array(postsSet)
        postsData = []
        
        for post in posts {
            var text = ""
            if post.title != nil {
                text = post.title!
            } else {
                let originalText = post.text
                let length = originalText.index(originalText.startIndex, offsetBy: 16)
                text = "..." + String(originalText[...length]) + "..."
            }
            let postLikesData = PostViewsLikes(
                id: post.id,
                text: text,
                value: post.likeCount,
                category: "Понравилось"
            )
            let postViewsData = PostViewsLikes(
                id: post.id,
                text: text,
                value: post.viewCount,
                category: "Просмотры"
            )
            postsData.append(postLikesData)
            postsData.append(postViewsData)
        }
        if posts.count > 5 {
            moreThenFivePosts = true
        }
        postsData = postsData.sorted {
            $0.value > $1.value
        }
    }
    
    // Как часто релиз и трек был отмечен слушателем (Favorited)
    private func getReleasesStats(artist: Artist) {
        guard let releasesSet = artist.releases else { return }
        let releases = Array(releasesSet as Set<Release>)
        
        var totalTracksLikes: Int64 = 0
        releasesData = []
        tracksData = []
        
        for release in releases {
            let tracks: [Track] = Array(release.tracks)
            for track in tracks {
                var totalTrackLikes: Int64 = 0
                totalTrackLikes += track.favoritedCount
                totalTracksLikes += track.favoritedCount
                
                let trackTotalFavorited = TrackTotalFavorited(
                    id: track.id,
                    name: "\(track.id)", // Пока используем ID т.к в примере повторяющиеся треки
                    favorited: track.favoritedCount
                )
                tracksData.append(trackTotalFavorited)
                if tracksData.count > 5 {
                    moreThenFiveTracks = true
                }
                tracksData = tracksData.sorted {
                    $0.favorited > $1.favorited
                }
            }
            
            let releaseTotalFavorited = ReleaseTotalFavorited(
                id: release.id,
                name: release.name,
                dateReleasedTS: release.dateReleasedTS,
                amountFavoritedTracks: totalTracksLikes
            )
            releasesData.append(releaseTotalFavorited)
            releasesData = releasesData.sorted {
                $0.dateReleasedTS > $1.dateReleasedTS
            }
        }
    }
    
}

//struct StatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatsView()
//    }
//}
