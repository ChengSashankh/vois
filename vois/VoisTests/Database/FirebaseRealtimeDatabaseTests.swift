//
//  FirebaseRealtimeDatabaseTests.swift
//  VoisTests
//
//  Created by Sashankh Chengavalli Kumar on 06.04.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import XCTest
import FirebaseDatabase
@testable import Vois

class FirebaseRealtimeDatabaseTests: XCTestCase {
    var firebaseRealtimeDatabaseAdapter = FirebaseRealtimeDatabaseAdapter()

    func testReadData() {
        let answer = firebaseRealtimeDatabaseAdapter.getData(at: "/databases/(default)/documents/comments/new")
        print(answer)
        XCTAssert(answer == "testValue")
    }

    func testWriteData() {
//        firebaseRealtimeDatabaseAdapter.writeData(key: "", value: "")
        let rootRef = Database.database().reference()
        rootRef.observe(.value, with: { snapshot in
          print(snapshot.value as Any)
        })
        rootRef.child("comments").setValue(["testNode": "b"])
    }

}

