//
//  Track+CoreDataProperties.swift
//  Artist
//
//  Created by Vladislav Green on 4/20/23.
//
//

import Foundation
import CoreData


extension Track {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }

    @NSManaged public var favoritedCount: Int64
    @NSManaged public var id: UUID
    @NSManaged public var number: Int64
    @NSManaged public var trackName: String
    @NSManaged public var trackURL: String
    @NSManaged public var ofRelease: Release

}

extension Track : Identifiable {}
