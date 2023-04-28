//
//  EditView.swift
//  Artist
//
//  Created by Vladislav Green on 3/10/23.
//

import SwiftUI
import KeychainAccess

struct EditView: View {
    
    @AppStorage("defaultArtistName") var defaultArtistName: String?
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name, order: .reverse)],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    @State private var showingProfileEditor = false
    @State private var showingArtistEditor = false
    @State private var isNewArtist: Bool = true
    
    
    var body: some View {
        
        Form {
            
            Section(header: Text("Choose an artist:".localized)) {
                
                Picker(selection: $defaultArtistName, label: Text("Choose:".localized)) {
                    if artists.count == 0 {
                        Text("Nothing loaded".localized).tag(nil as String?)
                    }
                    ForEach(artists) { artist in
                        Text(artist.name).tag(artist.name as String?)
                            .foregroundColor(.accentColor)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .clipped()
            }

            Section {
                Button(action: {
                    showingArtistEditor.toggle()
                    isNewArtist = false
                }) {
                    Text("Edit ".localized + (defaultArtistName ?? ""))
                }
                .sheet(isPresented: $showingArtistEditor) {
                    ArtistEditorView(isNewArtist: $isNewArtist)
                        .environment(\.managedObjectContext, self.viewContext)
                }
                
                Button(action: {
                    showingArtistEditor.toggle()
                    isNewArtist = true
                }) {
                    Text("Add new artist".localized)
                }
                .sheet(isPresented: $showingArtistEditor) {
                    ArtistEditorView(isNewArtist: $isNewArtist)
                        .environment(\.managedObjectContext, self.viewContext)
                }
            }
            
            Section(header: Text("My data".localized)) {
                Button(action: {
                    showingProfileEditor.toggle()
                }) {
                    Text("Change".localized)
                }
                .sheet(isPresented: $showingProfileEditor) {
                    ProfileEditorView()
                }
            }
            
            Section(header: Text("Other".localized)) {
                Button(action: {
                    CoreDataManager.shared.importJson(filename: "artistsData003.json")
                }) {
                    Text("Load default artists".localized)
                }
                
                Button(action: {
                    CoreDataManager.shared.exportCoreData()
                }) {
                    Text("Export JSON".localized)
                }
                
                Button(action: {
                    isLoggedIn = false
                }) {
                    Text("Quit".localized)
                }
            #if DEBUG
                Button(action: {
                    CoreDataManager.shared.clearDatabase()
                }) {
                    Text("Remove all artists".localized)
                }
            #endif
            }
        }
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
