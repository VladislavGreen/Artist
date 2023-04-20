//
//  Profile.swift
//  Artist
//
//  Created by Vladislav Green on 3/22/23.
//

import Foundation


struct Profile {
    var username: String
    var userEmail: String
    var prefersNotifications = true
    var userPermissions = Permission.creator
    var registrationDate = Date()
    var managedArtists: [Artist] = []

    static let `default` = Profile(username: "Manager Managerovitch", userEmail: "man@man.man")

    enum Permission: String, CaseIterable, Identifiable {
        case creator = "creator"
        case admin = "admin"
        case editor = "editor"
        case snowman = "snowman ☃️"

        var id: String { rawValue }
    }
}
