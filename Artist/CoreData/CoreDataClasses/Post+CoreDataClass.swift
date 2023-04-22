//
//  Post+CoreDataClass.swift
//  Artist
//
//  Created by Vladislav Green on 4/20/23.
//
//

import Foundation
import CoreData

@objc(Post)
public class Post: NSManagedObject, Codable {

    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[.contextUserInfoKey] as? NSManagedObjectContext else {
            throw ContextError.NoContextFound
        }
        self.init(context: context)
        
        let values = try decoder.container(keyedBy: PostCodingKeys.self)
        
        dateCreatedTS = try values.decode(Date.self, forKey: .dateCreatedTS)
        dateEditedTS = try values.decode(Date.self, forKey: .dateEditedTS)
        id = try values.decode(UUID.self, forKey: .id)
        imageName = try values.decodeIfPresent(String.self, forKey: .imageName)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        isFlagged = try values.decode(Bool.self, forKey: .isFlagged)
        likeCount = try values.decode(Int64.self, forKey: .likeCount)
        text = try values.decode(String.self, forKey: .text)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        viewCount = try values.decode(Int64.self, forKey: .viewCount)
        
//        ofArtist = try values.decode(Artist.self, forKey: .ofArtist)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var values = encoder.container(keyedBy: PostCodingKeys.self)
        
        try values.encode(dateCreatedTS, forKey: .dateCreatedTS)
        try values.encode(dateEditedTS, forKey: .dateEditedTS)
        try values.encode(id, forKey: .id)
        try values.encode(imageName, forKey: .imageName)
        try values.encode(imageURL, forKey: .imageURL)
        try values.encode(isFlagged, forKey: .isFlagged)
        try values.encode(likeCount, forKey: .likeCount)
        try values.encode(text, forKey: .text)
        try values.encode(title, forKey: .title)
        try values.encode(viewCount, forKey: .viewCount)
        
//        try values.encode(ofArtist, forKey: .ofArtist)
    }
    
    private enum PostCodingKeys: CodingKey {
        case
            dateCreatedTS,
            dateEditedTS,
            id,
            imageName,
            imageURL,
            isFlagged,
            likeCount,
            text,
            title,
            viewCount
        
//        ofArtist
    }
    
}
