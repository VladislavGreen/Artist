//
//  ReleaseItem.swift
//  Artist
//
//  Created by Vladislav Green on 3/19/23.
//

import SwiftUI

struct ReleaseItem: View {
    
    var release: Release
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if let imageURL = release.imageCoverURL {
                let downloadManager = DownloadManager()
                if downloadManager.getImageFromDefaults(imageURLString: imageURL) == nil {
                    AsyncImage(url: URL(string: imageURL)) { phase in
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
//                    .renderingMode(.original)
//                    .resizable()
                    .frame(width: 104, height: 104)
                    .cornerRadius(4)
                } else {
                    downloadManager.getImageFromDefaults(imageURLString: imageURL)!
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 104, height: 104)
//                        .cornerRadius(4)
                        .cornerRadius(24) // ❗️для того, чтобы видеть отличия
                }

                VStack {
                    Text(release.name)
#if DEBUG
                    Text(release.dateReleasedTS.formatted(date: .abbreviated, time: .omitted))
#endif
                }
                .foregroundColor(.textPrimary)
                .font(.caption)
            } else {
                Text("Пока нет релизов")
            }
        }
        .padding(.leading, 16)
        .padding(.bottom, 16)
            
    }
}


//#if DEBUG
//struct ReleaseItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ReleaseItem(release: ArtistModelData().artists[0].releases[0])
//    }
//}
//#endif
