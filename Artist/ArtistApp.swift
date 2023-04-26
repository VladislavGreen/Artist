//
//  ArtistApp.swift
//  Artist
//
//  Created by Vladislav Green on 3/7/23.
//

import SwiftUI

@main
struct ArtistApp: App {
    
//    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataManager.shared.context)
        }
//        .onChange(of: scenePhase) { _ in
//            CoreDataManager.shared.saveContext()
//        }
    }
}
