//
//  ArtistsResponseObjects.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 07.05.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

struct TrackArtist: Decodable {
    var name: String
    var mbid: String
    var url: String
}

struct TopArtistsAPIResponse: Decodable {
    var artists: ArtistsList
}

struct TopRegionalArtistsAPIResponse: Decodable {
    var topartists: ArtistsList
}

struct ArtistsList: Decodable {
    var artist: [TrackArtist]
}
