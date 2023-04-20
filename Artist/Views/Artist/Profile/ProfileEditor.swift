//
//  ProfileEditor.swift
//  Artist
//
//  Created by Vladislav Green on 3/22/23.
//

import SwiftUI

struct ProfileEditor: View {
    
    @Binding var profile: Profile
    
    var body: some View {
        List {
            HStack {
                Text("Username").bold()
                Divider()
                TextField("Username", text: $profile.username)
            }
            
            HStack {
                Text("Email").bold()
                Divider()
                TextField("Email", text: $profile.userEmail)
            }
            
            
            Toggle(isOn: $profile.prefersNotifications) {
                Text("Enable Notifications").bold()
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Permissions").bold()
                
                Picker("Permissions", selection: $profile.userPermissions) {
                    ForEach(Profile.Permission.allCases) { season in
                        Text(season.rawValue).tag(season)
                    }
                }
                .pickerStyle(.segmented)
            }
            
           
            Text("Registration Date").bold()
            
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default))
    }
}
