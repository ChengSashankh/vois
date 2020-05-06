//
//  TracksResponseObjects.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 07.05.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

struct TopTracksAPIResponse: Decodable {
    var tracks: TrackList
}

struct TrackList: Decodable {
    var track: [Track]
}

struct Track: Decodable {
    var name: String
    var duration: String
    var playcount: String?
    var listeners: String
    var mbid: String
    var url: String
    var artist: TrackArtist
}

struct TrackStreamable: Decodable {
    var text: String
    var fulltrack: String
}

struct TrackImage: Decodable {
    var text: String
    var size: String
}

struct TrackListAttributes: Decodable {
    var page: String
    var perPage: String
    var totalPages: String
    var total: String
}
