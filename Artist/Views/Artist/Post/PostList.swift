//
//  PostList.swift
//  Artist
//
//  Created by Vladislav Green on 3/15/23.
//

import SwiftUI

struct PostList: View {
    
    @AppStorage("defaultArtistName") var defaultArtistName: String?
    
    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        sortDescriptors: [SortDescriptor(\.name)],
//        animation: .default)
//    private var artists: FetchedResults<Artist>
    
    @State private var showFlaggedOnly = false
    @State var isPreview = false
    @State var showingPosts = false
    @State var showingDetail = false
    
    @State var posts: [Post]
    
    var body: some View {
        
        NavigationView {
            List {

                if !isPreview {
                    Toggle(isOn: $showFlaggedOnly) {
                        Text("Show flagged only")
                    }
                    
                    if showFlaggedOnly {
                        ForEach(posts) { post in
                            if post.isFlagged {
                                NavigationLink {
                                    PostDetail(post: post)
                                        .environment(\.managedObjectContext, self.viewContext)
                                } label: {
                                    PostRow(post: post)
                                        .environment(\.managedObjectContext, self.viewContext)
                                }
                            }
                        }
                        .navigationTitle("All news")
                    } else {
                        ForEach(posts) { post in
                            NavigationLink {
                                PostDetail(post: post)
                                    .environment(\.managedObjectContext, self.viewContext)
                            } label: {
                                PostRow(post: post)
                                    .environment(\.managedObjectContext, self.viewContext)
                            }
                        }
                        .navigationTitle("All news")
                    }
                }

                if isPreview {

                    FieldSeparator(title: "Recent News")
                        .onTapGesture {
                            showingPosts.toggle()
                        }
                        .sheet(isPresented: $showingPosts) {
                            PostList(isPreview: false, posts: posts)
                                .environment(\.managedObjectContext, self.viewContext)
                        }

                    ForEach(posts) { post in
                        if post.isFlagged {
                            PostRow(post: post)
                                .environment(\.managedObjectContext, self.viewContext)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            .listStyle(.plain)
        } 
//        .onReceive(artists.publisher, perform: { _ in
//            self.posts = posts
//                .filter {
//                    (post: Post) in (!showFlaggedOnly || post.isFlagged)
//                }
//        })
    }
}


//#if DEBUG
//struct PostList_Previews: PreviewProvider {
//    static var previews: some View {
//        PostList()
//            .environmentObject(ArtistModelData())
//    }
//}
//#endif
