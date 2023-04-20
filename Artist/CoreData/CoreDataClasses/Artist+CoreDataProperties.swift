//
//  Artist+CoreDataProperties.swift
//  Artist
//
//  Created by Vladislav Green on 4/20/23.
//
//

import Foundation
import CoreData


extension Artist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artist> {
        return NSFetchRequest<Artist>(entityName: "Artist")
    }

    @NSManaged public var city: String?
    @NSManaged public var countFollowers: Int64
    @NSManaged public var countLikes: Int64
    @NSManaged public var country: String?
    @NSManaged public var dateEditedTS: Date
    @NSManaged public var dateRegisteredTS: Date
    @NSManaged public var descriptionFull: String?
    @NSManaged public var descriptionShort: String?
    @NSManaged public var genrePrimary: String?
    @NSManaged public var genreSecondary: String?
    @NSManaged public var id: UUID
    @NSManaged public var isConfirmed: Bool
    @NSManaged public var isPrimary: Bool
    @NSManaged public var mainImageName: String?
    @NSManaged public var mainImageURL: String?
    @NSManaged public var name: String
    @NSManaged public var posts: Set<Post>?
    @NSManaged public var releases: Set<Release>?
}

extension Artist : Identifiable {}


//// MARK: Generated accessors for posts
//extension Artist {
//
//    @objc(addPostsObject:)
//    @NSManaged public func addToPosts(_ value: Post)
//
//    @objc(removePostsObject:)
//    @NSManaged public func removeFromPosts(_ value: Post)
//
//    @objc(addPosts:)
//    @NSManaged public func addToPosts(_ values: NSSet)
//
//    @objc(removePosts:)
//    @NSManaged public func removeFromPosts(_ values: NSSet)
//
//}
//
//// MARK: Generated accessors for releases
//extension Artist {
//
//    @objc(addReleasesObject:)
//    @NSManaged public func addToReleases(_ value: Release)
//
//    @objc(removeReleasesObject:)
//    @NSManaged public func removeFromReleases(_ value: Release)
//
//    @objc(addReleases:)
//    @NSManaged public func addToReleases(_ values: NSSet)
//
//    @objc(removeReleases:)
//    @NSManaged public func removeFromReleases(_ values: NSSet)
//
//}

