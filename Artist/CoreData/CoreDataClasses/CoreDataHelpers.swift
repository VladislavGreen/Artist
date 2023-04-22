//
//  CoreDataHelpers.swift
//  Artist
//
//  Created by Vladislav Green on 4/20/23.
//


extension CodingUserInfoKey {
    static let contextUserInfoKey = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum ContextError: Error {
    case NoContextFound
}


