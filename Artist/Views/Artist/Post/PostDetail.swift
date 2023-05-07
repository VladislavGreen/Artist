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
    
    @State var isEditMode = false
    
    var body: some View {
        
        ScrollView {
            
            HStack{
                Spacer()
                
                
            }
            
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
            .padding(.bottom, 8)
            
            PostQuickStat(post: post)

            if let imageURL = post.imageURL {
                ImageAsyncURL(imageURL: imageURL)
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



#if DEBUG
struct PostDetail_Previews: PreviewProvider {
    static var previews: some View {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let track1 = Track(context: viewContext)
        track1.favoritedCount = 12
        track1.id = UUID(uuidString: "E07ABFD8-429B-6A6A-AEDB-EE4C9E9A7C70")!
        track1.number = 1
        track1.trackName = "trackName"
        track1.trackURL = "https://drive.google.com/uc?export=open&id=1dzee5B6xD89AKkklvRnJ2Sz7LNNzTap4"
        
        let release1 = Release(context: viewContext)
        release1.dateEditedTS = Date(timeIntervalSince1970: 1672531200000)
        release1.dateReleasedTS = Date(timeIntervalSince1970: 1672531200000)
        release1.id = UUID(uuidString: "E07ABFD8-429B-4A5A-AEDB-EE4C9E9A7C94")!
        release1.imageCoverName = "imageCoverName"
        release1.imageCoverURL = "https://drive.google.com/uc?export=open&id=1gmSLscIWQoR0-DEBdWIf3fv6LKt38AsJ"
        release1.isFeatured = true
        release1.labelName = "labelName"
        release1.name = "Preview Release"
        release1.type = "Single"
        release1.tracks = [track1]
        
        let post1 = Post(context: viewContext)
        post1.dateCreatedTS = Date(timeIntervalSince1970: 1672531200000)
        post1.dateEditedTS = Date(timeIntervalSince1970: 1672531200000)
        post1.id = UUID(uuidString: "E07ABFD9-429B-4A5A-AEDB-EE4C9E9A7C94")!
        post1.imageName = "swiftUI"
        post1.imageURL = "https://drive.google.com/uc?export=open&id=1v-YWoixVfkBJOosYDvQN7KvGTctG8Hvl"
        post1.isFlagged = true
        post1.likeCount = 321
        post1.text = "Post text! By the way, should we limit the amount of symbols in a post or not? That's really interesting. Let's experiment later."
        post1.title = "Post title"
        post1.viewCount = 87
        
        let artist1 = Artist(context: viewContext)
        artist1.city = "city"
        artist1.countFollowers = 654
        artist1.countLikes = 54
        artist1.country = "country"
        artist1.dateEditedTS = Date(timeIntervalSince1970: 1672531200000)
        artist1.dateRegisteredTS = Date(timeIntervalSince1970: 1672531200000)
        artist1.descriptionFull = "descriptionFulldescriptionFulldescriptionFulldescriptionFulldescriptionFull"
        artist1.descriptionShort = "descriptionShort"
        artist1.genrePrimary = "genrePrimary"
        artist1.genreSecondary = "genreSecondary"
        artist1.id = UUID()
        artist1.isConfirmed = true
        artist1.isPrimary = true
        artist1.mainImageName = "PreviewTrio"
        artist1.mainImageURL = "https://drive.google.com/uc?export=open&id=1M893MdmN3phicZRKt8Npj6-R0r4HMYVk"
        artist1.name = "Artist Name From Persistance"
        artist1.releases = [release1]
        artist1.posts = [post1]

        try? viewContext.save()
        
        return PostDetail(post: post1)
            .environment(\.managedObjectContext, viewContext)
    }
        
//        PostDetail(post: )
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
}
#endif
