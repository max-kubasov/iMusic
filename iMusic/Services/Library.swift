//
//  Library.swift
//  iMusic
//
//  Created by Max on 04.02.2024.
//

import SwiftUI

struct Library: View {
    
    var tracks = UserDefaults.standard.savedTracks()
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack {
                        Button(action: {
                            print("12345")
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(.red))
                                .background(Color(.lightGray))
                                .cornerRadius(10)
                        })
                        
                        Button(action: {
                            print("54321")
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
                
                List(tracks) { track in
                    LibraryCell(cell: track)
                }
            }
            .navigationTitle("Library")
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

