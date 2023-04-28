//
//  DownloadManager.swift
//  Artist
//
//  Created by Vladislav Green on 4/27/23.
//  https://designcode.io/swiftui-advanced-handbook-download-files-locally-part-1

import Foundation
import SwiftUI
import AVKit


enum DownloadFileType {
        case artistImage
        case releaseImage
        case track
}

final class DownloadManager: ObservableObject {
    @Published var isDownloading = false
    @Published var isDownloaded = false
    
    
    /*
     1 получаем URL из поля URL CoreData
     2 скачиваем файл по URL
     3 сохраняем файл по уникальному пути в FileManager (папки взависимости от сущности)
     4 в comletion возвращаем этот путь или ошибку
     */
    
    func downloadAndSaveFile(folderName: String, fileName: String, fileType: DownloadFileType, url: String, completion: ((_ destinationURL: URL?, _ errorString: String?)->Void)?) {
            
        print("♻️ downloadFile")
        
        isDownloading = true
        
        // Пробуем привести в соответствие имена
        let trimmedFolderName = folderName.trimmingCharacters(in: .urlFragmentAllowed)
//        let trimmedFileName = fileName.trimmingCharacters(in: .urlFragmentAllowed)
        
        // Создаём папку
        let fileManager = FileManager.default
        let documentsFolder = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

        let folderURL = documentsFolder.appendingPathComponent(trimmedFolderName)
        let folderExists = (try? folderURL.checkResourceIsReachable()) ?? false
        do {
            if !folderExists {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: false)
            }
            
            // Получаем путь для сохранения файла в папку
            let destinationUrl = folderURL.appendingPathComponent(fileName)
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                print("File already exists")
                isDownloading = false
            } else {
                
                // Скачиваем файл
                let urlRequest = URLRequest(url: URL(string: url)!)

                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

                    if let error = error {
                        print("Request error: ", error)
                        self.isDownloading = false
                        completion? (nil, "Request error: \(error)")
                        return
                    }

                    guard let response = response as? HTTPURLResponse else {
                        print("response == nil")
                        completion? (nil, "response == nil")
                        return
                    }

                    if response.statusCode == 200 {
                        guard let data = data else {
                            self.isDownloading = false
                            completion? (nil, "data == nil")
                            return
                        }
                        
                        // Записываем файл
                        DispatchQueue.main.async {
                            do {
                                try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)

                                DispatchQueue.main.async {
                                    self.isDownloading = false
                                    self.isDownloaded = true
                                    
                                    completion? (destinationUrl, nil)
                                    
                                }
                            } catch let error {
                                print("Error decoding: ", error)
                                self.isDownloading = false
                                completion? (nil, "Error decoding while trying to write the file to destination URL")
                            }
                        }
                    }
                }
                dataTask.resume()
            }
            
        } catch {
            print("не удалось сохранить файл")
            completion? (nil, "не удалось сохранить файл")
        }
    }
    
    
    // Получение картинки по локальной ссылке
    func getImageFromDefaults(imageURLString: String) -> Image? {
        let userDefaults = UserDefaults.standard
        guard let imgURL: URL = userDefaults.url(forKey: imageURLString) else {
            return nil
        }
        if let imageData = try? Data(contentsOf: imgURL) {
            if let uiImage: UIImage = UIImage(data: imageData) {
                let image: Image = Image(uiImage: uiImage)
                return image
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    
    func deleteFile(destinationUrl: URL) {

        guard FileManager().fileExists(atPath: destinationUrl.path) else { return }
        do {
            try FileManager().removeItem(atPath: destinationUrl.path)
            print("File deleted successfully")
            isDownloaded = false
        } catch let error {
            print("Error while deleting file: ", error)
        }
    }

    func checkFileExists(destinationUrl: URL) {

            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                isDownloaded = true
            } else {
                isDownloaded = false
            }

    }

    func getFileAsset() -> AVPlayerItem? {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("myVideo.mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                let avAssest = AVAsset(url: destinationUrl)
                return AVPlayerItem(asset: avAssest)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
