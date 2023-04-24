//
//  StatsModels.swift
//  Artist
//
//  Created by Vladislav Green on 4/23/23.
//

import Foundation

struct ReleaseTotalFavorited: Identifiable {
    var id: UUID
    var name: String
    var dateReleasedTS: Date
    var amountFavoritedTracks: Int64
}

struct TrackTotalFavorited: Identifiable {
    var id: UUID
    var name: String
    var favorited: Int64
}

struct PostViewsLikes: Identifiable {
    var id: UUID
    var text: String
    var likes: Int64
    var views: Int64
}

