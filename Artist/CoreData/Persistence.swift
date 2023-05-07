//
//  Persistence.swift
//  Artist
//
//  Created by Vladislav Green on 4/20/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    // Convenience
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    static var preview: PersistenceController = {

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
        post1.imageName = "imageName"
        post1.imageURL = "imageURL"
        post1.isFlagged = true
        post1.likeCount = 321
        post1.text = "textENtextENtextENtextENtextENtextENtextENtextENtextENtextENtextENtextEN"
        post1.title = "titleEN"
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

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Artist")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print("❌ init error")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print("✅ init")
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
