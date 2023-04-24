//
//  PostRow.swift
//  Artist
//
//  Created by Vladislav Green on 3/15/23.
//

import SwiftUI

struct PostRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var post: Post
    @State var showingPostDetail = false
    
    var body: some View {
        HStack {
            HStack {
                
                if post.imageName != nil {
                    Image(post.imageName!)
                        .resizable()
                        .clipShape(Rectangle())
                        .scaledToFit()
                        .frame(height: 68)
                        .cornerRadius(12)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    HStack {
                        Text(post.title ?? "")
                            .font(CustomFont.subheading)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if post.isFlagged {
                            Image(systemName: "flag.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Text(post.text)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
            }
            .padding(8)
            .cornerRadius(4)
        }
        .onTapGesture {
            showingPostDetail.toggle()
        }
        .sheet(isPresented: $showingPostDetail) {
            PostDetail(post: post)
                .environment(\.managedObjectContext, self.viewContext)
        }
    }
}


//#if DEBUG
//struct PostRow_Previews: PreviewProvider {
//    
//    static var artists = ArtistModelData().artists
//    
//    static var previews: some View {
//        Group {
//            PostRow(post: artists[0].posts[1])
//            PostRow(post: artists[0].posts[1])
//        }
//        .previewLayout(.fixed(width: 200, height: 200))
//            
//    }
//}
//#endif
