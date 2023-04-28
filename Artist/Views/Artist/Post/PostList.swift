//
//  PostList.swift
//  Artist
//
//  Created by Vladislav Green on 3/15/23.
//

import SwiftUI

struct PostList: View {
    
    // Posts - нам нужны posts сразу после старта приложения, чтобы отображать их в ArtistView.
    // postsFetched - в то же время, нам нужно оперативно изменять что-то и отражать изменения
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.dateCreatedTS)],
        animation: .default)
    private var postsFetched: FetchedResults<Post>
    
    var artist: Artist
    @State var posts: [Post]
    
    @State private var showFlaggedOnly = false
    @State var isPreview = false
    @State var showingPosts = false
    @State var showingDetail = false
    
    var body: some View {
        
        NavigationView {
            List {
                if !isPreview {
                    Toggle(isOn: $showFlaggedOnly) {
                        Text("Show flagged only".localized)
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
                        .navigationTitle("All news".localized)
                        
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
                        .navigationTitle("All news".localized)
                    }
                }

                if isPreview {

                    FieldSeparator(title: "Recent News".localized)
                        .onTapGesture {
                            showingPosts.toggle()
                        }
                        .sheet(isPresented: $showingPosts) {
                            PostList(artist: artist, posts: posts, isPreview: false)
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
//        НЕ ПОЛУЧАЕТ ПРЕДИКАТА ПРИ ЗАПУСКЕ ПРИЛОЖЕНИЯ
       .onAppear {
           print("🆔 onAppear Post артист: \(artist.name)")
           postsFetched.nsPredicate = NSPredicate(format: "ofArtist == %@", artist)
           posts = Array(postsFetched)
       }
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
