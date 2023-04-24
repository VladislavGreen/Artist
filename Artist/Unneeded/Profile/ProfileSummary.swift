//
////  ProfileSummary.swift
////  Artist
////
////  Created by Vladislav Green on 3/22/23.
////
//
//import SwiftUI
//
//struct ProfileSummary: View {
//    
//    @FetchRequest(sortDescriptors: []) var artists: FetchedResults<Artist>
//    
//    var profile: Profile
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 10) {
//                Text(profile.username)
//                    .bold()
//                    .font(.title)
//                
//                Text(profile.userEmail)
//                    .font(.title)
//
//                Text("Notifications: \(profile.prefersNotifications ? "On": "Off" )")
//                Text("Permissions: \(profile.userPermissions.rawValue)")
//                Text("Registration Date: ") + Text(profile.registrationDate, style: .date)
//                
//                List(artists) { artist in
//                    Text(artist.name ?? "No artists added yet")
//                }
//            }
//        }
//    }
//}
//
//struct ProfileSummary_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSummary(profile: Profile.default)
//    }
//}
