//
//  Track+CoreDataClass.swift
//  Artist
//
//  Created by Vladislav Green on 4/20/23.
//
//

import Foundation
import CoreData

@objc(Track)
public class Track: NSManagedObject, Codable {
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[.contextUserInfoKey] as? NSManagedObjectContext else {
            throw ContextError.NoContextFound
        }
        self.init(context: context)
        
        // Декодируем
        let values = try decoder.container(keyedBy: TrackCodingKeys.self)
        
        favoritedCount = try values.decode(Int64.self, forKey: .favoritedCount)
        id = try values.decode(UUID.self, forKey: .id)
        number = try values.decode(Int64.self, forKey: .number)
        trackName = try values.decode(String.self, forKey: .trackName)
        trackURL = try values.decode(String.self, forKey: .trackURL)
        
//        ofRelease = try values.decode(Release.self, forKey: .ofRelease)
    }
    
    // Confirming Encoding
    public func encode(to encoder: Encoder) throws {
        
        // Encoding Item
        var values = encoder.container(keyedBy: TrackCodingKeys.self)
        
        try values.encode(favoritedCount, forKey: .favoritedCount)
        try values.encode(id, forKey: .id)
        try values.encode(number, forKey: .number)
        try values.encode(trackName, forKey: .trackName)
        try values.encode(trackURL, forKey: .trackURL)
        
//        try values.encode(ofRelease, forKey: .ofRelease)
    }
    
    private enum TrackCodingKeys: CodingKey {
        case
            favoritedCount,
            id,
            number,
            trackName,
            trackURL
        
//        ofRelease
    }
}
