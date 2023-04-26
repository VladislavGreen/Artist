//
//  ContentView.swift
//  Artist
//
//  Created by Vladislav Green on 3/7/23.
//  https://zendesk.engineering/app-onboarding-with-swiftui-23d970ab24d4


import SwiftUI
import CoreData


struct ContentView: View {
    
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    @AppStorage("defaultArtistName") var defaultArtistName: String?
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name, order: .reverse)],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    
    var body: some View {
        
        VStack {
            if artists.count != 0 {
                TabView() {
                ArtistView()
                    .environment(\.managedObjectContext, self.viewContext)
                    .tabItem {
                        Label("Profile", systemImage: "person.fill.checkmark")
                    }
                StatsView()
                    .environment(\.managedObjectContext, self.viewContext)
                    .tabItem {
                        Label("Stats", systemImage: "person")
                    }
                EditView()
                    .environment(\.managedObjectContext, self.viewContext)
                    .tabItem {
                        Label("Edit", systemImage: "person.fill.checkmark")
                    }
                }
            } else {
                VStack{
                    Text("Создадим Артиста?")
                    ArtistEditorView(isNewArtist: .constant(true))
                }
            }
        }
        .onAppear {
            refreshData() {
                getDefaultArtist()
            }
//            print("🆔 onAppear ContentView: Дефолтный артист: \(defaultArtistName)")
//            artists.nsPredicate = defaultArtistName?.isEmpty ?? true
//            ? nil
//            : NSPredicate(format: "name == %@", defaultArtistName!)
        }
//        .onChange(of: defaultArtistName ?? "") { value in
//            print("🆔 onChange ContentView: Дефолтный артист: \(defaultArtistName)")
//            artists.nsPredicate = defaultArtistName?.isEmpty ?? true
//            ? nil
//            : NSPredicate(format: "name == %@", value)
//        }

    }
    
    
    private func refreshData(completion: (()->(Void))? = nil) {
        if isFirstLaunch {
            print("🚩 Первый запуск!")
            CoreDataManager.shared.importJson(filename: "artistsData003.json")
            CoreDataManager.shared.saveData()
            isFirstLaunch = false
            completion?()
        } else {
            CoreDataManager.shared.loadData()
        }
    }
    
    func getDefaultArtist() {
        if artists.count  != 0 {
            for artist in artists {
                    defaultArtistName = artist.name
                    print("getDefaultArtist: по умолчанию: \(defaultArtistName)")
                    break
            }
        } else {
            print("artists.count = 0 ")
        }
    }
}


//#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
//#endif
