//
//  PostQuickStat.swift
//  Artist
//
//  Created by Vladislav Green on 5/5/23.
//

import SwiftUI

struct PostQuickStat: View {
    
    var post: Post
    
    var body: some View {
        HStack {
            Text(post.dateEditedTS == post.dateCreatedTS
                 ? "Created  \(post.dateEditedTS.formatted(.dateTime))"
                 : "Edited \(post.dateEditedTS.formatted(.dateTime))")
            Spacer()
            Image(systemName: "star")
            Text("\(post.likeCount)")
                .padding(.trailing, 8)
            Image(systemName: "eye")
            Text("\(post.viewCount)")
        }
        .font(CustomFont.small)
        .foregroundColor(.textSecondary)
    }
}


#if DEBUG
struct PostQuickStat_Previews: PreviewProvider {
    static var previews: some View {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let post1 = Post(context: viewContext)
        post1.dateCreatedTS = Date(timeIntervalSince1970: 1672531200000)
        post1.dateEditedTS = Date(timeIntervalSince1970: 1672531200000)
        post1.id = UUID(uuidString: "E07ABFD9-429B-4A5A-AEDB-EE4C9E9A7C94")!
        post1.imageName = "swiftUI"
        post1.imageURL = "imageURL"
        post1.isFlagged = true
        post1.likeCount = 321
        post1.text = "Post text! By the way, should we limit the amount of symbols in a post or not? That's really interesting. Let's experiment later."
        post1.title = "Post title"
        post1.viewCount = 87
        
//        let artist1 = Artist(context: viewContext)
//        artist1.posts = [post1]

        try? viewContext.save()
        
        return PostQuickStat(post: post1)
            .environment(\.managedObjectContext, viewContext)
    }
}
#endif
