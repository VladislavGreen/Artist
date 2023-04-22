//
//  Artist+CoreDataClass.swift
//  Artist
//
//  Created by Vladislav Green on 4/20/23.
//
//

import Foundation
import CoreData

@objc(Artist)
public class Artist: NSManagedObject, Codable {
    
    required convenience public init(from decoder: Decoder) throws {
        
        // Сначала, получаем контекст
        guard let context = decoder.userInfo[.contextUserInfoKey] as? NSManagedObjectContext else {
            throw ContextError.NoContextFound
        }
        self.init(context: context)
        
        // Декодируем
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        city = try values.decodeIfPresent(String.self, forKey: .city)
        countFollowers = try values.decode(Int64.self, forKey: .countFollowers)
        countLikes = try values.decode(Int64.self, forKey: .countLikes)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        dateEditedTS = try values.decode(Date.self, forKey: .dateEditedTS)
        dateRegisteredTS = try values.decode(Date.self, forKey: .dateRegisteredTS)
        descriptionFull = try values.decodeIfPresent(String.self, forKey: .descriptionFull)
        descriptionShort = try values.decodeIfPresent(String.self, forKey: .descriptionShort)
        genrePrimary = try values.decodeIfPresent(String.self, forKey: .genrePrimary)
        genreSecondary = try values.decodeIfPresent(String.self, forKey: .genreSecondary)
        id = try values.decode(UUID.self, forKey: .id)
        isConfirmed = try values.decode(Bool.self, forKey: .isConfirmed)
        isPrimary = try values.decode(Bool.self, forKey: .isPrimary)
        mainImageName = try values.decodeIfPresent(String.self, forKey: .mainImageName)
        mainImageURL = try values.decodeIfPresent(String.self, forKey: .mainImageURL)
        name = try values.decode(String.self, forKey: .name)
        
        releases = try values.decodeIfPresent(Set<Release>.self, forKey: .releases)
        posts = try values.decodeIfPresent(Set<Post>.self, forKey: .posts)
    }
    
    // Confirming Encoding
    public func encode(to encoder: Encoder) throws {
        
        // Encoding Item
        var values = encoder.container(keyedBy: CodingKeys.self)
        
        try values.encode(city, forKey: .city)
        try values.encode(countFollowers, forKey: .countFollowers)
        try values.encode(countLikes, forKey: .countLikes)
        try values.encode(country, forKey: .country)
        try values.encode(dateEditedTS, forKey: .dateEditedTS)
        try values.encode(dateRegisteredTS, forKey: .dateRegisteredTS)
        try values.encode(descriptionFull, forKey: .descriptionFull)
        try values.encode(descriptionShort, forKey: .descriptionShort)
        try values.encode(genrePrimary, forKey: .genrePrimary)
        try values.encode(genreSecondary, forKey: .genreSecondary)
        try values.encode(id, forKey: .id)
        try values.encode(isConfirmed, forKey: .isConfirmed)
        try values.encode(isPrimary, forKey: .isPrimary)
        try values.encode(mainImageName, forKey: .mainImageName)
        try values.encode(mainImageURL, forKey: .mainImageURL)
        try values.encode(name, forKey: .name)
        
        try values.encode(releases, forKey: .releases)
        try values.encode(posts, forKey: .posts)
    }
    
    private enum CodingKeys: CodingKey {
        case
            city,
            countFollowers,
            countLikes,
            country,
            dateEditedTS,
            dateRegisteredTS,
            descriptionFull,
            descriptionShort,
            genrePrimary,
            genreSecondary,
            id,
            isConfirmed,
            isPrimary,
            mainImageName,
            mainImageURL,
            name,
            releases,
            posts
    }
}
