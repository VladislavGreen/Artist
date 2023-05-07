//
//  ImageAsyncURL.swift
//  Artist
//
//  Created by Vladislav Green on 3/14/23.
//

import SwiftUI


struct ImageAsyncURL: View {
    
    var imageURL: String
    
    var body: some View {

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
        .clipShape(Rectangle())
        .scaledToFit()
        .shadow(radius: 4)
        .cornerRadius(12)
    }
}

//struct ImageDiskOrURL_Previews: PreviewProvider {
//    static var previews: some View {
//        AvatarImageView(imageName: "Rockstar1")
//    }
//}
