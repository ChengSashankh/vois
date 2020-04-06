//
//  FirebaseStorageAdapterTests.swift
//  VoisTests
//
//  Created by Sashankh Chengavalli Kumar on 06.04.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import XCTest
import FirebaseStorage
@testable import Vois

class FirebaseStorageAdapterTests: XCTestCase {
    var firebaseStorageAdapter = FirebaseStorageAdapter(bucketName: "gs://vois-239b7.appspot.com")
    var testFilePath = "recordings/vois audio background.png"
    var localFileName = "downloaded.png"

    func testDownloadFile() {
        let targetURL = firebaseStorageAdapter.getDocumentsDirectoryPath().appendingPathComponent(localFileName)
        let cloudFileReference = firebaseStorageAdapter.getReference(toPath: testFilePath)
        let downloadTask = cloudFileReference.write(toFile: targetURL)
        downloadTask.observe(.success) { snapshot in
            print("Success")
            print(snapshot)
        }

        downloadTask.observe(.failure) { snapshot in
            guard let errorCode = (snapshot.error as NSError?)?.code else {
              return
            }
            guard let error = StorageErrorCode(rawValue: errorCode) else {
              return
            }

            print("Error encountered: \(error)")
            XCTFail()
        }
//        let downloadTask = cloudFileReference.write(toFile: targetURL) { url, error in
//          if let error = error {
//            print("Error occured \(error)")
//          } else {
//            print("Download successful")
//
//            do {
//                let attr = try FileManager.default.attributesOfItem(atPath: targetURL.absoluteString)
//                print("Attributes are: \(attr)")
//            } catch {
//                print("Could not get attributes")
//            }
//          }
//        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
