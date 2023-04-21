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
        imageName = try values.decode(String.self, forKey: .imageName)
        imageURL = try values.decode(String.self, forKey: .imageURL)
        isFlagged = try values.decode(Bool.self, forKey: .isFlagged)
        likeCount = try values.decode(Int64.self, forKey: .likeCount)
        textEN = try values.decode(String.self, forKey: .textEN)
        textRU = try values.decode(String.self, forKey: .textRU)
        titleEN = try values.decode(String.self, forKey: .titleEN)
        titleRU = try values.decode(String.self, forKey: .titleRU)
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
        try values.encode(textEN, forKey: .textEN)
        try values.encode(textRU, forKey: .textRU)
        try values.encode(titleEN, forKey: .titleEN)
        try values.encode(titleRU, forKey: .titleRU)
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
            textEN,
            textRU,
            titleEN,
            titleRU,
            viewCount
        
//        ofArtist
    }
    
}
