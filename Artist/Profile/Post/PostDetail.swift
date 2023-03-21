//
//  PostDetail.swift
//  Artist
//
//  Created by Vladislav Green on 3/15/23.
//

import SwiftUI

struct PostDetail: View {
    
    @EnvironmentObject var artistModelData: ArtistModelData
    var post: Post
    
    var postIndex: Int {
        artistModelData.artists[0].posts.firstIndex(where: { $0.id == post.id })!
    }
    
    var body: some View {

        
        ScrollView {
            
            HStack {
                Text(post.titleEN)
                    .font(CustomFont.subheading)
                
                Spacer()
                
                FlagButton(isSet: $artistModelData.artists[0].posts[postIndex].isFlagged)
            }
            
            if post.image != nil {
                post.image?
                    .resizable()
                    .clipShape(Rectangle())
                    .scaledToFit()
            }
            
            Text(post.textEN)
                .padding(.bottom, 12)
            Text("Discussion section")
                
        }
        .padding(16)
        .navigationTitle(post.titleEN)
        .navigationBarTitleDisplayMode(.inline)
                

    }
}

struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        PostDetail(post: ArtistModelData().artists[0].posts[1])
            .environmentObject(ArtistModelData())
    }
}
