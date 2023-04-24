//
//  ContentView.swift
//  Artist
//
//  Created by Vladislav Green on 3/7/23.
//  https://zendesk.engineering/app-onboarding-with-swiftui-23d970ab24d4


import SwiftUI
import CoreData


struct ContentView: View {
    
    @AppStorage("defaultArtistName") var defaultArtistName: String?
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name, order: .reverse)],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    #if DEBUG
        @State var timeRemaining = 3
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    #endif
    
    var body: some View {
        
        
            VStack {
                if artists.count != 0 {
                    TabView() {
                    ArtistView(artist: artists.first!)
                        .environment(\.managedObjectContext, self.viewContext)
                        .tabItem {
                            Label("Profile", systemImage: "person.fill.checkmark")
                        }
//                        .fullScreenCover(isPresented:$needsAppOnboarding) {
//                            OnboardingView()
//                        }
//                        .fullScreenCover(isPresented:$isNotLoggedIn) {
//                            LoginView(tabSelection: .constant("LoginView"))
//                        }
                    StatsView(artist: artists.first!)
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
                    Text("Пока ничего не загружено. Можно придумать какую-нибудь картинку на этот случай.")
                }
                
                #if DEBUG
                    Button {
                        refreshData()
                    } label: {
                        Text("Load default JSON to CoreData")
                    }
                    
                    Button {
                        exportDataBaseAsJson()
                    } label: {
                        Text("Print current database as JSON")
                    }
                    
                    Button {
                        clearDataBase()
                    } label: {
                        Text("Clear Database")
                    }
                    
                    Spacer()
                #endif
            }
            .onChange(of: defaultArtistName ?? "") { value in
                artists.nsPredicate = defaultArtistName?.isEmpty ?? true
                ? nil
                : NSPredicate(format: "name == %@", value)
            }
            .onAppear {
                refreshData()
                getDefaultArtist()
                print(defaultArtistName)
            }
//            #if DEBUG
//                .onAppear {
//                    getDefaultArtist()
//                }
//                .onReceive(timer) {_ in
//                    if timeRemaining > 0 {
//                        timeRemaining -= 1
//                    }
//                    if timeRemaining == 0 {
//                        print("Start")
//                        refreshData()
//                        self.timer.upstream.connect().cancel()
//                    }
//                }
//            #endif
        
    }
    
    private func getDefaultArtist() {
        if artists.count  != 0 {
            for artist in artists {
                    defaultArtistName = artist.name
                    break
            }
        } else {
            print("artists.count = 0 ")
        }
    }
    
    private func refreshData() {
        CoreDataManager.shared.importJson(filename: "artistsData003.json")
    }
    
    private func exportDataBaseAsJson() {
        CoreDataManager.shared.exportCoreData()
    }
    
    private func clearDataBase() {
        CoreDataManager.shared.clearDatabase()
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
