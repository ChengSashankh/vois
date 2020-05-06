////
////  APIInterface.swift
////  Vois
////
////  Created by Sashankh Chengavalli Kumar on 06.05.20.
////  Copyright © 2020 Vois. All rights reserved.
////
//
//import Foundation
//
//extension Dictionary {
//    mutating func merge(toMerge: [Key: Value]) {
//        for (newKey, newValue) in toMerge {
//            updateValue(newValue, forKey: newKey)
//        }
//    }
//}
//
//extension Date {
//    func asString(format: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        return dateFormatter.string(from: self)
//    }
//}
//
//class LastFMAPIInterface {
//    var apiKey: String
//    var rootUrl = "https://ws.audioscrobbler.com/2.0/"
//
//    init(apiKey: String) {
//        self.apiKey = apiKey
//    }
//
//    convenience init() {
//        self.init(apiKey: "")
//    }
//
//    func setApiKey(newKey: String) {
//        apiKey = newKey
//    }
//    
//    func getTopTracks() {
//    }
//    
//}
