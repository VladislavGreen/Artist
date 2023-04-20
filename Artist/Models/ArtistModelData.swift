//
//  ArtistModelData.swift
//  Artist
//
//  Created by Vladislav Green on 3/15/23.
//

import Foundation
import Combine



final class ArtistModelData: ObservableObject {
//    @Published var defaultArtists: [ArtistCodable] = JsonReader.shared.load("artistsData002.json")
    @Published var profile = Profile.default
    
//    var featuredReleases: [ReleaseCodable] {
//        defaultArtists[0].releases.filter { $0.isFeatured }
//    }
    
//    var releaseTypes: [String: [ReleaseCodable]] {
//        Dictionary(
//            grouping: defaultArtists[0].releases,
//            by: { $0.type.rawValue }
//        )
//    }
}

