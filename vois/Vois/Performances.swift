//
//  Performances.swift
//  Vois
//
//  Created by Tan Yong He on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class Performances: Codable, StorageObservable {
    private var performances: [Performance]

    var storageObserverDelegate: StorageObserverDelegate? {
        didSet {
            for performance in performances {
                performance.storageObserverDelegate = storageObserverDelegate
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case performances
    }

    var hasNoPerformances: Bool {
        return performances.isEmpty
    }

    var numOfPerformances: Int {
        return performances.count
    }

    init () {
        self.performances = []
    }

    init (_ performances: [Performance]) {
        self.performances = performances

        for performance in performances {
            performance.storageObserverDelegate = storageObserverDelegate
        }
    }

    func addPerformance(performance: Performance) {
        self.performances.append(performance)
        performance.storageObserverDelegate = storageObserverDelegate
        storageObserverDelegate?.update(operation: .update, object: self)
    }

    func updatePerformance(oldPerformance: Performance, newPerformance: Performance) {
        guard let index = self.performances.firstIndex(of: oldPerformance) else {
            return
        }
        self.performances[index] = newPerformance
        newPerformance.storageObserverDelegate = storageObserverDelegate
        storageObserverDelegate?.update(operation: .update, object: self)
        storageObserverDelegate?.update(operation: .delete, object: oldPerformance)
    }

    func removePerformance(performance: Performance) {
        guard let index = self.performances.firstIndex(of: performance) else {
            return
        }
        self.performances.remove(at: index)
        storageObserverDelegate?.update(operation: .delete, object: performance)
    }

    func removePerformance(at index: Int) {
        let performance = self.performances.remove(at: index)
        storageObserverDelegate?.update(operation: .delete, object: performance)
    }

    func getPerformances() -> [Performance] {
        return self.performances
    }

    func getPerformances(at index: Int) -> Performance {
        return self.performances[index]
    }

    func removeAllPerformances() {
        self.performances.forEach {
            storageObserverDelegate?.update(operation: .delete, object: $0)
        }
        self.performances = []
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
