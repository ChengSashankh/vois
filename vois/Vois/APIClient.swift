//
//  APIClient.swift
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

class APIClient {
    var baseParams = [
        "api_key": "5a83c80e13a39002a4c841b72cf8427d",
        "format": "json"
    ]
    var rootUrl = "https://ws.audioscrobbler.com/2.0/"

    func setBaseParams(newParams: [String: String]) {
        baseParams = newParams
    }

    func constructUrlQueryString(parameters: [String: String]) -> String {
        var queryString = ""

        for (key, value) in parameters {
            queryString += (key + "=" + value + "&")
        }

        if queryString.last == Character("&") {
            queryString = String(queryString.dropLast())
        }

        return queryString
    }

    func getTopTracks(completionHandler: @escaping (_ response: TopTracksAPIResponse?) -> Void) {
        var options = [
            "method": "chart.gettoptracks"
        ]
        options.merge(toMerge: baseParams)

        let completeRequestString = rootUrl + "?" + constructUrlQueryString(parameters: options)

        if let url = URL(string: completeRequestString) {
           URLSession.shared.dataTask(with: url) { data, _, _ in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    let apiResponse = ResponseParser().parseTopTracksResponse(asString: jsonString)
                    completionHandler(apiResponse)
                 }
              }
           }.resume()
        }
    }

    func getTopArtists(completionHandler: @escaping (_ response: TopArtistsAPIResponse?) -> Void) {
        var options = [
            "method": "chart.gettopartists"
        ]
        options.merge(toMerge: baseParams)

        let completeRequestString = rootUrl + "?" + constructUrlQueryString(parameters: options)

        if let url = URL(string: completeRequestString) {
           URLSession.shared.dataTask(with: url) { data, _, _ in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    let apiResponse = ResponseParser().parseTopArtistsResponse(asString: jsonString)
                    completionHandler(apiResponse)
                 }
              }
           }.resume()
        }
    }

    func getTopTracksByRegion(country: String, completionHandler:
        @escaping (_ response: TopTracksAPIResponse?) -> Void) {

        var options = [
            "country": country,
            "method": "geo.gettoptracks"
        ]
        options.merge(toMerge: baseParams)

        let completeRequestString = rootUrl + "?" + constructUrlQueryString(parameters: options)

        if let url = URL(string: completeRequestString) {
           URLSession.shared.dataTask(with: url) { data, _, _ in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    let apiResponse = ResponseParser().parseTopTracksResponse(asString: jsonString)
                    completionHandler(apiResponse)
                 }
              }
           }.resume()
        }
    }

    func getTopArtistsByRegion(country: String, completionHandler:
        @escaping (_ response: TopRegionalArtistsAPIResponse?) -> Void) {
        var options = [
            "country": country,
            "method": "geo.gettopartists"
        ]
        options.merge(toMerge: baseParams)

        let completeRequestString = rootUrl + "?" + constructUrlQueryString(parameters: options)

        if let url = URL(string: completeRequestString) {
           URLSession.shared.dataTask(with: url) { data, _, _ in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    let apiResponse = ResponseParser().parseRegionalTopArtistsResponse(asString: jsonString)
                    completionHandler(apiResponse)
                 }
              }
           }.resume()
        }
    }

}
