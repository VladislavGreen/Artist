//
//  ImageDiskOrURL.swift
//  Artist
//
//  Created by Vladislav Green on 3/14/23.
//

import SwiftUI


struct ImageDiskOrURL: View {
    
    var imageURL: String
    
    var body: some View {
        
        let downloadManager = DownloadManager()
        if downloadManager.getImageFromDefaults(imageURLString: imageURL) == nil {
            ImageAsyncURL(imageURL: imageURL)
                .clipShape(Rectangle())
                .scaledToFit()
                .shadow(radius: 4)
                .cornerRadius(12)
        } else {
            downloadManager.getImageFromDefaults(imageURLString: imageURL)!
                .resizable()
                .clipShape(Rectangle())
                .scaledToFit()
                .shadow(radius: 4)
        }
    }
}

//struct ImageDiskOrURL_Previews: PreviewProvider {
//    static var previews: some View {
//        AvatarImageView(imageName: "Rockstar1")
//    }
//}
