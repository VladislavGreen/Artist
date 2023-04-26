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
            
            Section(header: Text("Выберите артиста:")) {
                
                Picker(selection: $defaultArtistName, label: Text("Выбрать:")) {
                    if artists.count == 0 {
                        Text("Ничего не загружено").tag(nil as String?)
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
                    Text("Редактировать " + (defaultArtistName ?? ""))
                }
                .sheet(isPresented: $showingArtistEditor) {
                    ArtistEditorView(isNewArtist: $isNewArtist)
                        .environment(\.managedObjectContext, self.viewContext)
                }
                
                Button(action: {
                    showingArtistEditor.toggle()
                    isNewArtist = true
                }) {
                    Text("Добавить нового артиста")
                }
                .sheet(isPresented: $showingArtistEditor) {
                    ArtistEditorView(isNewArtist: $isNewArtist)
                        .environment(\.managedObjectContext, self.viewContext)
                }
            }
            
            Section(header: Text("Мои данные")) {
                Button(action: {
                    showingProfileEditor.toggle()
                }) {
                    Text("Изменить")
                }
                .sheet(isPresented: $showingProfileEditor) {
                    ProfileEditorView()
                }
            }
            
            Section(header: Text("Разное")) {
                Button(action: {
                    CoreDataManager.shared.importJson(filename: "artistsData003.json")
                }) {
                    Text("Загрузить образцы профилей артистов")
                }
                
                Button(action: {
                    CoreDataManager.shared.exportCoreData()
                }) {
                    Text("Экспорт JSON")
                }
                
                Button(action: {
                    CoreDataManager.shared.clearDatabase()
                }) {
                    Text("Удалить всех артистов")
                }
                
                
            }
        }
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
