//
//  CoreDataManager.swift
//  Artist
//
//  Created by Vladislav Green on 4/13/23.
//

import Foundation
import CoreData


class CoreDataManager {
    
    var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    static let shared = CoreDataManager()
    private init(){}
    
    private let fileURL = URL(
        fileURLWithPath: "Artists",
        relativeTo: FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
    ).appendingPathExtension("json")
    
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
                print("Saving context")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // Чтение данных из файла JSON из ХCode (дефолтная база)
    func importJson(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            print("Couldn't find \(filename) in main bundle.")
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.userInfo[.contextUserInfoKey] = context
            decoder.dateDecodingStrategy = .millisecondsSince1970
            let artistsImported = try decoder.decode([Artist].self, from: jsonData)
            print("♻️ Обновляем CoreData из \(filename)")
            saveContext()
            checkDuplicates(artistsImported)
        } catch {
            print("Что-то пошло не так")
            print(error)
        }
    }
    
    // Проверка дубликатов по ID
    func checkDuplicates(_ artists: [Artist]) {

        for i in 0..<artists.count {
            let fetchRequestCheck = Artist.fetchRequest()
            fetchRequestCheck.predicate = NSPredicate(format: "id == %@", artists[i].id as CVarArg)
            let results = try? context.fetch(fetchRequestCheck)
            guard results?.first != nil else {
                print("\(String(describing: results?.first?.name)) Imported successfully")
                return
            }
            if results!.count > 1 {
                let result = results?.first
                // ⭕️ хорошо бы сделать проверку по дате последней редакции timestamp
                print("\(String(describing: artists[i].name)) уже есть удаляем дубликат")
                deleteArtist(result!)
            }
            
        }
    }
    
    func deleteArtist(_ artist: Artist, completion: (()->(Void))? = nil) {
        print("❌ deleteArtist \(String(describing: artist.name))")
        context.delete(artist)
        saveContext()
        completion?()
    }
    
    func clearDatabase() {
        let fetchRequest = Artist.fetchRequest()
        for artist in (try? context.fetch(fetchRequest)) ?? [] {
            deleteArtist(artist)
        }
        print("❌ Всё удалено")
    }
    
    
    // Экспорт данных из CoreData в виде JSON в виде нового файла
    func exportCoreData() {
        do {
            // 1 Fetching
            if let entityName = Artist.entity().name {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let items = try context.fetch(request).compactMap {
                    $0 as? Artist
                    // Здесь можно будет использовать предикаты (если данных много) и отображать прогресс
                }
                
                // 2 Конвертируем в JSON
                let jsonData = try JSONEncoder().encode(items)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("✅ Данные после конвертации в JSON:  \(jsonString)")
                    
                    // 3 Сохраняем пока в Temporary Document
                    if let tempURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        
                        let pathURL = tempURL.appending(
                            component: "Export\(Date().formatted(date: .complete, time: .omitted)).json")
                        try jsonString.write(to: pathURL, atomically: true, encoding: .utf8)
                        // Успешное сохранение
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    
    // Сохранение данных в файловую систему в виде JSON
    func saveData() {
        self.saveContext()
        do {
            // 1 Fetching
            if let entityName = Artist.entity().name {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let items = try context.fetch(request).compactMap {
                    $0 as? Artist
                    // Здесь можно будет использовать предикаты (если данных много) и отображать прогресс
                }
                
                // 2 Конвертируем в JSON
                let jsonData = try JSONEncoder().encode(items)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    print("✅ Данные после конвертации в JSON:  \(jsonString)")
                    
                    // 3 Сохраняем

                    do {
                        try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
                        print("♻️ Сохраняем CoreData в Artists.json")
                    } catch {
                        print("Не хаватает свободного места?")
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    // Чтение данных JSON из файловой системы
    func loadData() {

        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.userInfo[.contextUserInfoKey] = context
            decoder.dateDecodingStrategy = .millisecondsSince1970
            let artistsImported = try decoder.decode([Artist].self, from: jsonData)
            print("♻️ Обновляем CoreData из Artists.json")
            saveContext()
            checkDuplicates(artistsImported)
        } catch {
            print("Что-то пошло не так")
            print(error)
        }
    }

}






//class CoreDataManager {
//    static let shared = CoreDataManager()
//
//    // наполнение данными:
//    func setCoreData(artist: ArtistCodable, context: NSManagedObjectContext, completion: (()->())?) {
//        let newArtist = Artist(context: context)
//        newArtist.id = artist.id
//        newArtist.city = artist.artistOrigin.city
//        newArtist.countFollowers = artist.countFollowers
//        newArtist.countLikes = artist.countLikes
//        newArtist.country = artist.artistOrigin.country
//        newArtist.dateRegistered = artist.dateRegistered
//        newArtist.dateRegisteredTS = artist.dateRegisteredTS
//        newArtist.descriptionFull = artist.descriptionFull
//        newArtist.descriptionShort = artist.descriptionShort
//        newArtist.genrePrimary = artist.genres.genrePrimary
//        newArtist.genreSecondary = artist.genres.genreSecondary
//        newArtist.isConfirmed = artist.isConfirmed
//        newArtist.isPrimary = artist.isPrimary
//        newArtist.mainImageName = artist.mainImageName
//        newArtist.mainImageURL = artist.mainImageURL
////        newArtist.name = artist.name
//        newArtist.name = "Preview Artist Name"
//
//
//        let newPosts: [Post] = []
//        for post in artist.posts {
//            let newPost = Post(context: context)
//            newPost.date = post.date
//            newPost.dateTS = post.dateTS
//            newPost.id = post.id
//            newPost.imageName = post.imageName
//            newPost.imageURL = post.imageURL
//            newPost.isFlagged = post.isFlagged
//            newPost.likeCount = post.likeCount
//            newPost.textEN = post.textEN
//            newPost.textRU = post.textRU
//            newPost.titleEN = post.titleEN
//            newPost.titleRU = post.titleRU
//            newPost.viewCount = post.viewCount
//        }
//        newArtist.posts = NSSet.init(array: newPosts)
//
//        var newReleases: [Release] = []
//        for release in artist.releases {
//            let newRelease = Release(context: context)
//            newRelease.dateReleased = release.dateReleased
//            newRelease.dateReleasedTS = release.dateReleasedTS
//            newRelease.id = release.id
//            newRelease.imageCoverName = release.imageCoverName
//            newRelease.imageCoverURL = release.imageCoverURL
//            newRelease.isFeatured = release.isFeatured
//            newRelease.labelName = release.labelName
//            newRelease.name = release.name
//            newRelease.type = release.type.rawValue
//
//            var newTracks: [Track] = []
//            for track in release.tracks {
//                let newTrack = Track(context: context)
//                newTrack.favoritedCount = track.favoritedCount
//                newTrack.id = track.id
//                newTrack.number = track.number
//                newTrack.trackName = track.trackName
//                newTrack.trackURL = track.trackURL
//
//                newTracks.append(newTrack)
//            }
//
//            newRelease.tracks = NSSet.init(array: newTracks)
//            newReleases.append(newRelease)
//        }
//        newArtist.releases = NSSet.init(array: newReleases)
//
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }

    
    
