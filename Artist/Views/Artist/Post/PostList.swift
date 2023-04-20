//
//  PostList.swift
//  Artist
//
//  Created by Vladislav Green on 3/15/23.
//

import SwiftUI

struct PostList: View {
    
    @Environment(\.managedObjectContext) var moContext
    @FetchRequest(sortDescriptors: []) var artists: FetchedResults<Artist>
    
    @EnvironmentObject var artist: Artist
    
    @State private var showFlaggedOnly = false
    @State var isPreview = false
    @State var showingPosts = false
    
    var filteredPosts: [Post] {
        Array(artist.posts! as Set<Post>).filter { (post: Post) in
            (!showFlaggedOnly || post.isFlagged)
        }
    }
    
    var body: some View {
        
        NavigationView {
            List {
                
                if !isPreview {
                    Toggle(isOn: $showFlaggedOnly) {
                        Text("Show flagged only")
                    }
                }
                
                if isPreview {
                    
                    FieldSeparator(title: "Recent News")
                        .onTapGesture {
                            showingPosts.toggle()
                        }
                        .sheet(isPresented: $showingPosts) {
                            PostList(
                                isPreview: false
                            )
                        }
                    
                    ForEach(filteredPosts) { post in
                        if post.isFlagged {
                            PostRow(post: post)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    
                } else {
                    ForEach(filteredPosts) { post in
                        NavigationLink {
                            PostDetail(post: post)
                        } label: {
                            PostRow(post: post)
                        }
                    }
                    .navigationTitle("All news")
                }
            }
            .listStyle(.plain)
        }
    }
}

//struct PostList_Previews: PreviewProvider {
//    static var previews: some View {
//        PostList()
//            .environmentObject(ArtistModelData())
//    }
//}
