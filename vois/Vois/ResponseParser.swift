//
//  ResponseParser.swift
//  Vois
//
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class ResponseParser {
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

    func parseRegionalTopArtistsResponse(asString: String) -> TopRegionalArtistsAPIResponse? {
        let stringData = asString.data(using: .utf8)
        let apiResponse: TopRegionalArtistsAPIResponse?

        do {
            apiResponse = try JSONDecoder().decode(TopRegionalArtistsAPIResponse.self, from: stringData!)
        } catch {
            return nil
        }

        return apiResponse
    }
}
