//
//  PostDetail.swift
//  Artist
//
//  Created by Vladislav Green on 3/15/23.
//

import SwiftUI

struct PostDetail: View {
    
    @Environment(\.managedObjectContext) private var viewContext
   
    @State private var flag = false
    @State var post: Post
    
    var body: some View {
        
        ScrollView {
            
            HStack {
                Text(post.title ?? "No title".localized)
                    .font(CustomFont.subheading
                )
                
                Spacer()
                
                Button {
                    flag.toggle()
                    post.isFlagged.toggle()
                    CoreDataManager.shared.saveContext()
                    viewContext.refreshAllObjects()

                } label: {
                    Label("Toggle Flag", systemImage: flag ? "flag.fill" : "flag")
                        .labelStyle(.iconOnly)
                        .foregroundColor(flag ? .yellow : .gray)
                }
            }
            
            if let imageName = post.imageName {
                Image(imageName)
                    .resizable()
                    .clipShape(Rectangle())
                    .scaledToFit()
            }
            
            Text(post.text)
                .padding(.bottom, 12)
            Text("Discussion section".localized)
                
        }
        .padding(16)
        .navigationTitle(post.title ?? "No title".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            flag = post.isFlagged
        }
    }
}

//#if DEBUG
//struct PostDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PostDetail(post: ArtistModelData().artists[0].posts[1])
//            .environmentObject(ArtistModelData())
//    }
//}
//#endif
