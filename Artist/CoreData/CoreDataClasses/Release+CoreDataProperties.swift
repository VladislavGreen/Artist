//
//  Release+CoreDataProperties.swift
//  Artist
//
//  Created by Vladislav Green on 4/20/23.
//
//

import Foundation
import CoreData


extension Release {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Release> {
        return NSFetchRequest<Release>(entityName: "Release")
    }

    @NSManaged public var dateEditedTS: Date
    @NSManaged public var dateReleasedTS: Date
    @NSManaged public var id: UUID
    @NSManaged public var imageCoverName: String?
    @NSManaged public var imageCoverURL: String?
    @NSManaged public var isFeatured: Bool
    @NSManaged public var labelName: String?
    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var ofArtist: Artist
    @NSManaged public var tracks: Set<Track>
}

extension Release : Identifiable {}

//// MARK: Generated accessors for tracks
//extension Release {
//
//    @objc(addTracksObject:)
//    @NSManaged public func addToTracks(_ value: Track)
//
//    @objc(removeTracksObject:)
//    @NSManaged public func removeFromTracks(_ value: Track)
//
//    @objc(addTracks:)
//    @NSManaged public func addToTracks(_ values: NSSet)
//
//    @objc(removeTracks:)
//    @NSManaged public func removeFromTracks(_ values: NSSet)
//
//}


