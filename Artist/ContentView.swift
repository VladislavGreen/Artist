//
//  ContentView.swift
//  Artist
//
//  Created by Vladislav Green on 3/7/23.
//  https://zendesk.engineering/app-onboarding-with-swiftui-23d970ab24d4


import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
//    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = false
//    @AppStorage("isNotLoggedIn") private var isNotLoggedIn = false
    
    
    var body: some View {
        
        VStack {
            Spacer()
            ArtistView()
            Spacer()
            
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
        }
        .onReceive(timer) {_ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
            if timeRemaining == 0 {
                print("Start")
                refreshData()
                self.timer.upstream.connect().cancel()
            }
        }

//        TabView() {
//            ArtistView()
//                .tabItem {
//                    Label("Profile", systemImage: "person.fill.checkmark")
//                }
//                .fullScreenCover(isPresented:$needsAppOnboarding) {
//                    OnboardingView()
//                }
//                .fullScreenCover(isPresented:$isNotLoggedIn) {
//                    LoginView(tabSelection: .constant("LoginView"))
//                }
//            StatsView()
//                .tabItem {
//                    Label("Stats", systemImage: "person.fill.checkmark")
//                }
//            EditView()
//                .tabItem {
//                    Label("Edit", systemImage: "person.fill.checkmark")
//                }
//
//        }
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
