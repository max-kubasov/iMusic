//
//  UserDefaults.swift
//  iMusic
//
//  Created by Max on 07.02.2024.
//

import Foundation

extension UserDefaults {
    
    static let favouriteTrackKey = "favouriteTrackKey"
    
    func savedTracks() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        
        guard let savedTracks = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data else { return [] }
        guard let decodedTraks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] else { return [] }
        return decodedTraks
    }
}
