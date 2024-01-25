//
//  SearchResponse.swift
//  iMusic
//
//  Created by Max on 25.01.2024.
//

import Foundation

struct SearchResponse: Codable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Codable {
    var trackName: String?
    var artistName: String
    var collectionName: String?
    var artworkUrl100: String?
}
