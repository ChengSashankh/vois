//
//  APIInterface.swift
//  Vois
//
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func merge(toMerge: [Key: Value]) {
        for (newKey, newValue) in toMerge {
            updateValue(newValue, forKey: newKey)
        }
    }
}

struct TopTracksAPIResponse: Decodable {
    var tracks: TrackList
}

struct TrackList: Decodable {
    var track: [Track]
}

struct Track: Decodable {
    var name: String
    var duration: String
    var playcount: String
    var listeners: String
    var mbid: String
    var url: String
    var artist: TrackArtist
}

struct TrackStreamable: Decodable {
    var text: String
    var fulltrack: String
}

struct TrackArtist: Decodable {
    var name: String
    var mbid: String
    var url: String
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

struct TopArtistsAPIResponse: Decodable {
    var artists: ArtistsList
}

struct ArtistsList: Decodable {
    var artist: [TrackArtist]
}

class LastFMAPInterface {
    var apiKey: String
    var rootUrl = "https://ws.audioscrobbler.com/2.0/"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    convenience init() {
        self.init(apiKey: "")
    }

    func setApiKey(newKey: String) {
        apiKey = newKey
    }

    func parseTopTracksResponse(asString: String) -> TopTracksAPIResponse? {
        let stringData = asString.data(using: .utf8)
        let apiResponse: TopTracksAPIResponse?

        do {
            apiResponse = try JSONDecoder().decode(TopTracksAPIResponse.self, from: stringData!)
        } catch {
            return nil
        }

        return apiResponse
    }

    func parseTopArtistsResponse(asString: String) -> TopArtistsAPIResponse? {
        let stringData = asString.data(using: .utf8)
        let apiResponse: TopArtistsAPIResponse?

        do {
            apiResponse = try JSONDecoder().decode(TopArtistsAPIResponse.self, from: stringData!)
        } catch {
            return nil
        }

        return apiResponse
    }


    func getTopTracks(completionHandler: @escaping (_ response: TopTracksAPIResponse?) -> Void) {
        let url = "https://ws.audioscrobbler.com/2.0/"
        let options = [
            "method": "chart.gettoptracks",
            "api_key": "5a83c80e13a39002a4c841b72cf8427d",
            "format": "json"
        ]

        var completeRequestString = url + "?"

        for (key, value) in options {
            completeRequestString += (key + "=" + value + "&")
        }

        if completeRequestString.last == Character("&") {
            completeRequestString = String(completeRequestString.dropLast())
        }

        if let url = URL(string: completeRequestString) {
           URLSession.shared.dataTask(with: url) { data, _, _ in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    let apiResponse = self.parseTopTracksResponse(asString: jsonString)
                    completionHandler(apiResponse)
                 }
              }
           }.resume()
        }
    }

    func getTopArtists(completionHandler: @escaping (_ response: TopArtistsAPIResponse?) -> Void) {
        let url = "https://ws.audioscrobbler.com/2.0/"
        let options = [
            "method": "chart.gettopartists",
            "api_key": "5a83c80e13a39002a4c841b72cf8427d",
            "format": "json"
        ]

        var completeRequestString = url + "?"

        for (key, value) in options {
            completeRequestString += (key + "=" + value + "&")
        }

        if completeRequestString.last == Character("&") {
            completeRequestString = String(completeRequestString.dropLast())
        }

        if let url = URL(string: completeRequestString) {
           URLSession.shared.dataTask(with: url) { data, _, _ in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    let apiResponse = self.parseTopArtistsResponse(asString: jsonString)
                    completionHandler(apiResponse)
                 }
              }
           }.resume()
        }
    }
}
