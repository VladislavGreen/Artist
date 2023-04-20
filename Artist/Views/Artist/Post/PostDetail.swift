//
//  PostDetail.swift
//  Artist
//
//  Created by Vladislav Green on 3/15/23.
//

import SwiftUI

struct PostDetail: View {
    
//    @EnvironmentObject var artistModelData: ArtistModelData
    @EnvironmentObject var artist: Artist

    
    var post: Post
    
    var postIndex: Int {
        Array(artist.posts! as Set<Post>).firstIndex(where: { $0.id == post.id })!
    }
    
    var body: some View {

        
        ScrollView {
            
            HStack {
                Text(post.titleEN ?? "No title")
                    .font(CustomFont.subheading)
                
                Spacer()
                
//                FlagButton(isSet: $artistModelData.artist.posts[postIndex].isFlagged)
                
//               🛑 let isFlagged = Array($artist.posts as! Set<Post>)[postIndex].isFlagged
//                FlagButton(isSet: isFlagged)
            }
            
            if post.imageName != nil {
                Image(post.imageName!)
                    .resizable()
                    .clipShape(Rectangle())
                    .scaledToFit()
            }
            
            Text(post.textEN ?? "No text")
                .padding(.bottom, 12)
            Text("Discussion section")
                
        }
        .padding(16)
        .navigationTitle(post.titleEN ?? "No title")
        .navigationBarTitleDisplayMode(.inline)
                

    }
}

//struct PostDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PostDetail(post: ArtistModelData().artists[0].posts[1])
//            .environmentObject(ArtistModelData())
//    }
//}
