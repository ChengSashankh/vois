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

    var storageObserverDelegate: StorageObserverDelegate? {
        didSet {
            for performance in performances {
                performance.storageObserverDelegate = storageObserverDelegate
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case performances
        case id
    }

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

        for performance in performances {
            performance.storageObserverDelegate = storageObserverDelegate
        }
    }

    func addPerformance(performance: Performance) {
        self.performances.append(performance)
        performance.storageObserverDelegate = storageObserverDelegate
        storageObserverDelegate?.update(updateRecordings: false)
    }

    func updatePerformance(oldPerformance: Performance, newPerformance: Performance) {
        guard let index = self.performances.firstIndex(of: oldPerformance) else {
            return
        }
        self.performances[index] = newPerformance
        newPerformance.storageObserverDelegate = storageObserverDelegate
        storageObserverDelegate?.update(updateRecordings: true)
    }

    func removePerformance(performance: Performance) {
        guard let index = self.performances.firstIndex(of: performance) else {
            return
        }
        self.performances.remove(at: index)
        storageObserverDelegate?.update(updateRecordings: true)
    }

    func removePerformance(at index: Int) {
        self.performances.remove(at: index)
        storageObserverDelegate?.update(updateRecordings: true)
    }

    func getPerformances() -> [Performance] {
        return self.performances
    }

    func getPerformances(at index: Int) -> Performance {
        return self.performances[index]
    }

    func removeAllPerformances() {
        self.performances = []
        storageObserverDelegate?.update(updateRecordings: true)
    }

    func encodeToJson() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    convenience init?(json: Data) {
        guard let newValue = try? JSONDecoder().decode(Performances.self, from: json) else {
            return nil
        }
        self.init(newValue.performances)
    }
}
