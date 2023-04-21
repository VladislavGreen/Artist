//
//  Release+CoreDataClass.swift
//  Artist
//
//  Created by Vladislav Green on 4/20/23.
//
//

import Foundation
import CoreData

@objc(Release)
public class Release: NSManagedObject, Codable {
    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[.contextUserInfoKey] as? NSManagedObjectContext else {
            throw ContextError.NoContextFound
        }
        self.init(context: context)
        
        // Декодируем
        let values = try decoder.container(keyedBy: ReleaseCodingKeys.self)
        
        dateEditedTS = try values.decode(Date.self, forKey: .dateEditedTS)
        dateReleasedTS = try values.decode(Date.self, forKey: .dateReleasedTS)
        id = try values.decode(UUID.self, forKey: .id)
        imageCoverName = try values.decode(String.self, forKey: .imageCoverName)
        imageCoverURL = try values.decode(String.self, forKey: .imageCoverURL)
        isFeatured = try values.decode(Bool.self, forKey: .isFeatured)
        labelName = try values.decode(String.self, forKey: .labelName)
        name = try values.decode(String.self, forKey: .name)
        type = try values.decode(String.self, forKey: .type)
        
        tracks = try values.decode(Set<Track>.self, forKey: .tracks)
        
//        ofArtist = try values.decode(Artist.self, forKey: .ofArtist)
    }
    
    // Confirming Encoding
    public func encode(to encoder: Encoder) throws {
        // Encoding Item
        var values = encoder.container(keyedBy: ReleaseCodingKeys.self)
        
        try values.encode(dateEditedTS, forKey: .dateEditedTS)
        try values.encode(dateReleasedTS, forKey: .dateReleasedTS)
        try values.encode(id, forKey: .id)
        try values.encode(imageCoverName, forKey: .imageCoverName)
        try values.encode(imageCoverURL, forKey: .imageCoverURL)
        try values.encode(isFeatured, forKey: .isFeatured)
        try values.encode(labelName, forKey: .labelName)
        try values.encode(name, forKey: .name)
        try values.encode(type, forKey: .type)
        
        try values.encode(tracks, forKey: .tracks)
        
//        try values.encode(ofArtist, forKey: .ofArtist)
    }
    
    private enum ReleaseCodingKeys: CodingKey {
        case
            dateEditedTS,
            dateReleasedTS,
            id,
            imageCoverName,
            imageCoverURL,
            isFeatured,
            labelName,
            name,
            type,
            tracks
//             ofArtist
    }
}
