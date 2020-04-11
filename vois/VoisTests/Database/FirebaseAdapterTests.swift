//
//  FirebaseAdapterTests.swift
//  VoisTests
//
//  Created by Sashankh Chengavalli Kumar on 05.04.20.
//  Copyright © 2020 Vois. All rights reserved.

import XCTest
@testable import Vois

class FirebaseAdapterTests: XCTestCase {

    func testReadMethod() {
        var firebaseAdapter = FirestoreAdapter()
        print("Should be able to see the tests here")
        print(firebaseAdapter.textComments)
    }

    func testUpdateMethod() {
        var firebaseAdapter = FirestoreAdapter()
        firebaseAdapter.updateObject(inCollection: "comments", withId: "NWrEMG0fVKhFHhD1lq3j", newData: [
            "author": "newauthor"
        ])
    }

    func testgivencode() {
        var firestoreAdapter = FirestoreAdapter()
        firestoreAdapter.exampleCode()
    }
}
