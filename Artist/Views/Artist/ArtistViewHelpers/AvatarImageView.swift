//
//  AvatarView.swift
//  Artist
//
//  Created by Vladislav Green on 3/14/23.
//

import SwiftUI

struct AvatarImageView: View {
    
    
    var mainImageURL: String
    
    var body: some View {
        
        let downloadManager = DownloadManager()
        if downloadManager.getImageFromDefaults(imageURLString: mainImageURL) == nil {
            AsyncImage(url: URL(string: mainImageURL)) { phase in
                switch phase {
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                    case .success(let image):
                        image .resizable()
                    default:
                        ProgressView()
                }
            }
                .clipShape(Rectangle())
                .scaledToFit()
                .shadow(radius: 4)
        } else {
            downloadManager.getImageFromDefaults(imageURLString: mainImageURL)!
                .resizable()
                .clipShape(Rectangle())
                .scaledToFit()
                .shadow(radius: 4)
                .cornerRadius(24) // ❗️для того, чтобы видеть отличия
        }
    }
}

//struct AvatarImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        AvatarImageView(imageName: "Rockstar1")
//    }
//}
