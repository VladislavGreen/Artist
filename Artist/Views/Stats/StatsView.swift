//
//  StatsView.swift
//  Artist
//
//  Created by Vladislav Green on 3/10/23.
//

import SwiftUI
import Charts


struct StatsView: View {
    
    var artist: Artist
    
    @State var releasesData: [ReleaseTotalFavorited] = []
    @State var tracksData: [TrackTotalFavorited] = []
    @State var moreThenFiveTracks: Bool = false
    @State var postViewsLikes: [PostViewsLikes] = []
    
    var body: some View {
        
        VStack {
            
            Text("Ого! У \(artist.name) уже \(artist.countFollowers) слушателей")
                .padding(.vertical, 48)
            
            VStack {
                Text("Количество прослушиваний:")
                Chart(releasesData) {
                    BarMark(
                        x: .value("Plays", $0.amountFavoritedTracks),
                        y: .value("Name", $0.name)
                    )
                    
                }
                .frame(height: CGFloat(releasesData.count*54))
                .foregroundColor(.red)
            }
            .frame(height: 250)
            
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
            .frame(height: 300)
            
        }
        .padding(16)
        .onAppear {
            getReleasesStats(artist: artist)
            for track in tracksData {
                print(track.id)
            }
        }
    }
    
    // Как часто релиз и трек был отмечен слушателем
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
