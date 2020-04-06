//
//  PerformancesTest.swift
//  VoisTests
//
//  Created by Tan Yong He on 22/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import XCTest
@testable import Vois

class PerformancesTest: XCTestCase {
    let performances = Performances()
    let performanceOne = Performance(name: "PerformanceOne", date: Date(timeIntervalSince1970: 123_456_789))
    let performanceTwo = Performance(name: "PerformanceTwo", date: Date(timeIntervalSince1970: 123_456_789))

    func testNoSegments() {
        XCTAssertTrue(performances.hasNoPerformances)
    }

    func testNumOfSongs() {
        XCTAssertEqual(performances.numOfPerformances, 0)
        performances.addPerformance(performance: performanceOne)
        XCTAssertEqual(performances.numOfPerformances, 1)
        performances.addPerformance(performance: performanceTwo)
        XCTAssertEqual(performances.numOfPerformances, 2)
        performances.updatePerformance(oldPerformance: performanceOne, newPerformance: performanceTwo)
        XCTAssertEqual(performances.numOfPerformances, 2)
        performances.removePerformance(performance: performanceTwo)
        XCTAssertEqual(performances.numOfPerformances, 1)
        performances.removeAllPerformances()
        XCTAssertEqual(performances.numOfPerformances, 0)
    }

    func testAddPerformance() {
        performances.addPerformance(performance: performanceOne)
        XCTAssertTrue(performances.getPerformances().elementsEqual([performanceOne]))
        performances.addPerformance(performance: performanceTwo)
        XCTAssertTrue(performances.getPerformances().elementsEqual([performanceOne, performanceTwo]))
        performances.addPerformance(performance: performanceOne)
        XCTAssertTrue(performances.getPerformances().elementsEqual([performanceOne, performanceTwo, performanceOne]))
    }

    func testRemovePerformance() {
        performances.addPerformance(performance: performanceOne)
        performances.addPerformance(performance: performanceTwo)
        performances.addPerformance(performance: performanceOne)

        performances.removePerformance(performance: performanceTwo)
        XCTAssertTrue(performances.getPerformances().elementsEqual([performanceOne, performanceOne]))
        performances.removePerformance(performance: performanceOne)
        XCTAssertTrue(performances.getPerformances().elementsEqual([performanceOne]))
        performances.removePerformance(performance: performanceOne)
        XCTAssertTrue(performances.getPerformances().isEmpty)
    }

    func testUpdatePerformance() {
        performances.addPerformance(performance: performanceOne)
        XCTAssertTrue(performances.getPerformances().elementsEqual([performanceOne]))
        performances.addPerformance(performance: performanceTwo)
        XCTAssertTrue(performances.getPerformances().elementsEqual([performanceOne, performanceTwo]))
        performances.updatePerformance(oldPerformance: performanceOne, newPerformance: performanceTwo)
        XCTAssertTrue(performances.getPerformances().elementsEqual([performanceTwo, performanceTwo]))
    }

    func testRemoveAllPerformances() {
        XCTAssertTrue(performances.hasNoPerformances)

        performances.addPerformance(performance: performanceOne)
        performances.addPerformance(performance: performanceTwo)

        XCTAssertFalse(performances.hasNoPerformances)
        performances.removeAllPerformances()
        XCTAssertTrue(performances.hasNoPerformances)
    }
}
