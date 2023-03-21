//
//  Artist.swift
//  Artist
//
//  Created by Vladislav Green on 3/15/23.
//

import Foundation
import SwiftUI


struct Artist: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var dateRegistered: String
    var dateRegisteredTS: Int
    var isConfirmed: Bool
    var isPrimary: Bool
    
    private var artistOrigin: ArtistOrigin
    struct ArtistOrigin: Hashable, Codable {
        var country: String
        var city: String
    }
    
    private var genres: Genres
    struct Genres: Hashable, Codable {
        var genrePrimary: String
        var genreSecondary: String
    }
    
    var descriptionFull: String
    var descriptionShort: String
    var countFolowers: Int
    var countLikes: Int
    
    private var mainImageName: String
    var mainImage: Image {
        Image(mainImageName)
    }
    
    var posts: [Post]
    var releases: [Release]
}


struct Post: Hashable, Codable, Identifiable {
    var id: Int
    var date: String
    var dateTS: Int
    var titleEN: String
    var titleRU: String
    var textEN: String
    var textRU: String
    
    private var imageName: String?
    var image: Image? {
        guard imageName != nil else {
            return nil
        }
        return Image(imageName!)
    }
        
    var likeCount: Int
    var viewCount: Int
    var isFlagged: Bool
}


struct Release: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    
    var type: ReleaseType
    enum ReleaseType: String, CaseIterable, Codable {
        case album = "Album"
        case ep = "EP"
        case single = "Single"
    }
    
    var isFeatured: Bool
    var dateReleased: String
    var dateReleasedTS: Int
    
    private var imageCoverName: String
    var imageCover: Image {
        Image(imageCoverName)
    }
    
    var labelName: String
    
    var tracks: [Track]
}


struct Track: Hashable, Codable, Identifiable {
    var id: Int
    var number: Int
    var trackName: String
    var playedTenDaysCount: [Int]
    var favoritedCount: Int
}

