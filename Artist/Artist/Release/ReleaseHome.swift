//
//  Release.swift
//  Artist
//
//  Created by Vladislav Green on 3/18/23.
//

import SwiftUI


struct ReleaseHome: View {
    
    @EnvironmentObject var artistModelData: ArtistModelData
    
    var body: some View {
        NavigationView {
            List {
                
                ZStack{
                    artistModelData.featuredReleases[0].imageCover
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .listRowInsets(EdgeInsets())
                    
                    VStack {
                        
                        Spacer()
                        
                        HStack {
                            
                            Text("Featured")
                                .font(CustomFont.heading)
                                .colorInvert()
                                .padding(.leading, 16)
                            Spacer()
                        }
                        .padding(.bottom, 16)
                    }
                        
                }
                .listRowInsets(EdgeInsets())
                
                ForEach(artistModelData.releaseTypes.keys.sorted(), id: \.self) { key in
                    ReleaseRow(releaseType: key, items: artistModelData.releaseTypes[key]!, isSortedByType: true)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.inset)
            .navigationTitle("Discography")
        }
    }
}

struct ReleaseHome_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseHome()
            .environmentObject(ArtistModelData())
    }
}
