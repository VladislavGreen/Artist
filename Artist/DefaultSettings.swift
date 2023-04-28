//
//  DefaultSettings.swift
//  Artist
//
//  Created by Vladislav Green on 4/20/23.
//


//enum DefaultSettings {
//    static let defaultArtistName = ""
//}

/*
 Может быть, лучше определять дефолтного артиста по UUID. Вообще, там, похоже, сложности с соответствием RawRepresentable, но есть вот такое решение:
 
 We can confirm UUID to RawRepresentable protocol so it fits to one of AppStorage init.

 Here is a possible approach. Tested with Xcode 13.2 / iOS 15.2

 extension UUID: RawRepresentable {
     public var rawValue: String {
         self.uuidString
     }

     public typealias RawValue = String

     public init?(rawValue: RawValue) {
         self.init(uuidString: rawValue)
     }
 }
 and then your original (below) code just works 'as-is'

 @AppStorage("navigationWaypointID") var navigationWaypointID: UUID?
 */

