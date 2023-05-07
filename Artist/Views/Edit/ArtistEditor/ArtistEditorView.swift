//
//  ArtistEditorView.swift
//  Artist
//
//  Created by Vladislav Green on 4/24/23.
//  https://www.hackingwithswift.com/quick-start/swiftui/how-to-load-a-remote-image-from-a-url

import SwiftUI

struct ArtistEditorView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name)],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("defaultArtistName") var defaultArtistName: String?
    
    @State private var isEmptyNameAlert = false
    @State private var isDeleteAlert = false
    
    @State var name: String = ""
    @State var descriptionShort: String = ""
    @State var descriptionShortDefaultText = "Brief description (150 symbols)"
    @State var mainImageURL: String = ""
    
    // Пока не реализовано:
    @State var descriptionFull: String = ""
    @State var mainGenre: String = ""
    @State var secondaryGenre: String = ""
    @State var country: String = ""
    @State var city: String = ""
    
    
    @Binding var isNewArtist: Bool
    
    @State var gDiskLink: String = ""
    
    var body: some View {
        
        Form {
            Section(header: Text("Required fields".localized)) {
                
                VStack {
                    TextField("Enter Artist name".localized, text: $name)                  // Reqired
                        .disableAutocorrection(true)
                        .frame(alignment: .leading)
                        .font(CustomFont.subheading)
                        .foregroundColor(.accentColor)
                    
                    HStack {
                        VStack{
                            if mainImageURL != "" {
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
                                .frame(width: 64, height: 64)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            } else {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.backgroundSecondary)
                            }
                        }
                        .frame(width: 64)
                        
                        ZStack {
                            TextEditor(text: $descriptionShort)
                                .disableAutocorrection(true)
                                .lineLimit(...3)
                                .foregroundColor(.accentColor)
                                .onTapGesture {
                                    descriptionShortDefaultText = ""
                                    
                                }
                            Text(isNewArtist ? descriptionShortDefaultText : "")
                                .opacity(0.3)
                                .padding(16)
                                .zIndex(0)
                                .allowsHitTesting(false)
                        }
                        
                    }
                    .frame(height: 64)
                    
                    TextField("Enter Artist image URL".localized, text: $mainImageURL)
                        .disableAutocorrection(true)
                }
            }
            
            Section(header: Text("Convert gDisk link".localized)) {
                VStack {
                    TextField("Paste gDisk link".localized, text: $gDiskLink)
                        .disableAutocorrection(true)
                    Button(action: {
                        formatGoogleDiscLinkToURL(gdiskLink: gDiskLink)
                        
                    }) {
                        Text("Add".localized)
                    }
                }
            }
            
            Section {
                Button (isNewArtist ? "Add Artist".localized : "Confirm changes".localized) {
                    isNameEmptyCheck(name: name)
                    
                    if !isEmptyNameAlert {
                        
                        let artist = isNewArtist
                        ? Artist(context: viewContext)
                        : artists.first
                        artist?.name = self.name
                        artist?.descriptionShort = self.descriptionShort
                        artist?.mainImageURL = self.mainImageURL
                        artist?.id = UUID()
                        artist?.dateEditedTS = Date(timeIntervalSinceNow: 0)
                        if isNewArtist {
                            artist?.dateRegisteredTS = Date(timeIntervalSinceNow: 0)
                        }
                        
                        CoreDataManager.shared.saveData()
                        
                        defaultArtistName = self.name
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                }
                .alert(isPresented: $isEmptyNameAlert) {
                   Alert(
                    title: Text("Alert".localized),
                        message: Text("Artist needs a name".localized),
                        dismissButton: .destructive(Text("ok")) {
                            isEmptyNameAlert = false
                                self.name = isNewArtist ? "" : artists.first?.name ?? ""
                        }
                    )
                }
            }
            
            Spacer()
            
            Section {
                Button {
                    isDeleteAlert = true
                } label: {
                    Text("DELETE current artist)".localized)
                }
                .disabled(artists.count == 0)
            }
            .alert(isPresented: $isDeleteAlert) {
                Alert(
                    title: Text("Alert".localized),
                    message: Text("Are you sure".localized),
                    primaryButton: .destructive(Text("Delete".localized)) {
                        CoreDataManager.shared.deleteArtist(artists.first!) {
                            if artists.count  != 0 {
                                for artist in artists {
                                        defaultArtistName = artist.name
                                        break
                                }
                            } else {
                                print("artists.count = 0 ")
                            }
                        }
                        CoreDataManager.shared.saveData()
                        
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .onAppear {
            if isNewArtist {
                descriptionShort = ""
                mainImageURL = ""
                name = ""
            } else {
                artists.nsPredicate = defaultArtistName?.isEmpty ?? true
                ? nil
                : NSPredicate(format: "name == %@", defaultArtistName!)
                
                descriptionShort = artists.first?.descriptionShort ?? ""
                mainImageURL = artists.first?.mainImageURL ?? ""
                name = artists.first?.name ?? ""
            }
        }
        .onChange(of: defaultArtistName ?? "") { value in
            artists.nsPredicate = defaultArtistName?.isEmpty ?? true
            ? nil
            : NSPredicate(format: "name == %@", value)
        }
    }
    
    // Конвертация ссылок гугл-диска в применимый формат
    private func formatGoogleDiscLinkToURL(gdiskLink: String) {
        let text = gdiskLink.replacingOccurrences(of: "file/d/", with: "uc?export=open&id=")
        let url = text.replacingOccurrences(of: "/view?usp=share_link", with: "")
        mainImageURL = url
    }
    
    
    // Проверки
    private func isNameEmptyCheck(name: String) {
        let filter = name.filter {!$0.isWhitespace}
        print("❓ \(filter)")
        print(filter.count)
        if filter.count < 1 {
            isEmptyNameAlert = true
        }
    }
}

//struct ArtistEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArtistEditorView()
//    }
//}
