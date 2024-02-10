//
//  Library.swift
//  iMusic
//
//  Created by Max on 04.02.2024.
//

import SwiftUI

struct Library: View {
    
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var showingAlert = false
    @State private var track: SearchViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack {
                        Button(action: {
                            self.track = self.tracks[0]
                            self.tabBarDelegate?.maximizeTrackDetailControler(viewModel: self.track)
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(.red))
                                .background(Color(.lightGray))
                                .cornerRadius(10)
                        })
                        
                        Button(action: {
                            self.tracks = UserDefaults.standard.savedTracks()
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(.red))
                                .background(Color(.lightGray))
                                .cornerRadius(10)
                        })
                    }
                }.padding().frame(height: 50)
                
                Divider().padding()
                
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track)
                            .gesture(LongPressGesture()
                                .onEnded({ _ in
                                    print("PRESSED!------------")
                                    self.track = track
                                    self.showingAlert = true
                                })
                                    .simultaneously(with: TapGesture()
                                        .onEnded({ _ in
                                            
                                            let keyWindow = UIApplication
                                                .shared
                                                .connectedScenes
                                                .compactMap { $0 as? UIWindowScene }
                                                .flatMap { $0.windows }
                                                .last { $0.isKeyWindow }
                                            
                                            print("----------\(keyWindow)")
                                            
                                            let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                                            
                                            tabBarVC?.trackDetailView.delegate = self
                                            
                                            self.track = track
                                            self.tabBarDelegate?.maximizeTrackDetailControler(viewModel: self.track )
                                        })))
                    }
                    .onDelete(perform: delete)
                }
            }
            .actionSheet(isPresented: $showingAlert, content: {
                ActionSheet(title: Text("Are you sure you want to delete this tarck? "), buttons: [.destructive(Text("Delete"), action: {
                    print("Deleting \(self.track.trackName)")
                    self.delete(track: self.track)
                }), .cancel()
                                                                                                  ])
            })
            .navigationTitle("Library")
        }
        
    }
     
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
    func delete(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return }
        tracks.remove(at: myIndex)
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
}

struct LibraryCell: View {
    
    let cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {

            AsyncImage(
                url: URL(string: cell.iconUrlString ?? ""),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 60, maxHeight: 60)
                        .cornerRadius(5)
                },
                placeholder: {
                    ProgressView()
                }
            )
            
            
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
        
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

extension Library: TrackMovingDelegate {
    
    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        print("123")
        return nil
    }
    
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        print("321")
        return nil
    }
    
    
}

