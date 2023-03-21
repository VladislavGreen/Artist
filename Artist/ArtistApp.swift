//
//  ArtistApp.swift
//  Artist
//
//  Created by Vladislav Green on 3/7/23.
//

import SwiftUI

@main
struct ArtistApp: App {
    @StateObject private var artistModelData = ArtistModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(artistModelData)
        }
    }
}
