//
//  Post+CoreDataProperties.swift
//  Artist
//
//  Created by Vladislav Green on 4/20/23.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var dateEditedTS: Date
    @NSManaged public var dateCreatedTS: Date
    @NSManaged public var id: UUID
    @NSManaged public var imageName: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var isFlagged: Bool
    @NSManaged public var likeCount: Int64
    @NSManaged public var textEN: String?
    @NSManaged public var textRU: String?
    @NSManaged public var titleEN: String?
    @NSManaged public var titleRU: String?
    @NSManaged public var viewCount: Int64
    @NSManaged public var ofArtist: Artist?

}

extension Post : Identifiable {}
