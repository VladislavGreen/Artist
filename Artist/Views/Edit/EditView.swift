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
    
//    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
//    @AppStorage("isNotLoggedIn") private var isNotLoggedIn = false
    
    var body: some View {
        
        VStack{
            
            Text("Select an artist:")
            
            Picker(selection: $defaultArtistName, label: Text("Select an artist")) {
                if artists.count == 0 {
                    Text("No artist loaded").tag(nil as String?)
                }
                ForEach(artists) { artist in
                    Text(artist.name).tag(artist.name as String?)
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
