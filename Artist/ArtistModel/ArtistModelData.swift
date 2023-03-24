//
//  ArtistModelData.swift
//  Artist
//
//  Created by Vladislav Green on 3/15/23.
//

import Foundation
import Combine


final class ArtistModelData: ObservableObject {
    @Published var artists: [Artist] = load("artistsData001.json")
    @Published var profile = Profile.default
    
    var featuredReleases: [Release] {
        artists[0].releases.filter { $0.isFeatured }
    }
    
    var releaseTypes: [String: [Release]] {
        Dictionary(
            grouping: artists[0].releases,
            by: { $0.type.rawValue }
        )
    }
}

//var artists: [Artist] = load("artistsData001.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        print("Couldn't find \(filename) in main bundle.")
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        print("Couldn't find \(filename) in main bundle.")
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print("Couldn't find \(filename) in main bundle.")
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
