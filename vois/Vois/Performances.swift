//
//  Performances.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class Performances: Codable, Serializable {
    private var performances: [Performance]
    var id: String

    var dictionary: [String: Any] {
        return [
            "performances": performances,
            "id": id
        ]
    }

    var hasNoPerformances: Bool {
        return performances.isEmpty
    }

    var numOfPerformances: Int {
        return performances.count
    }

    init () {
        self.performances = []
        id = UUID().uuidString
    }

    init (_ performances: [Performance]) {
        self.performances = performances
        self.id = UUID().uuidString
    }

    func addPerformance(performance: Performance) {
        self.performances.append(performance)
    }

    func updatePerformance(oldPerformance: Performance, newPerformance: Performance) {
        guard let index = self.performances.firstIndex(of: oldPerformance) else {
            return
        }
        self.performances[index] = newPerformance
    }

    func removePerformance(performance: Performance) {
        guard let index = self.performances.firstIndex(of: performance) else {
            return
        }
        self.performances.remove(at: index)
    }

    func getPerformances() -> [Performance] {
        return self.performances
    }

    func getPerformances(at index: Int) -> Performance {
        return self.performances[index]
    }

    func removeAllPerformances() {
        self.performances = []
    }
}
