//
//  StartViewController.swift
//  Vois
//
//  Created by Tan Yong He on 15/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit
import FirebaseAuth

class StartViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let firestoreAdapter = FirestoreAdapter()

//        firestoreAdapter.writeObject(inCollection: "test", data: [
//            "a": "b"
//        ])

//        firestoreAdapter.writeObject(inCollection: "test", withId: "abcd", data: [
//            "a": "b"
//        ])

//        firestoreAdapter.deleteObject(inCollection: "comments", withId: "help2")

//        firestoreAdapter.updateObject(inCollection: "comments", withId: "help", newData: [
//            "whereis": "allthedata"
//        ])

        // did not work
//        do {
//            let data = try firestoreAdapter.readObject(inCollection: "comments", withId: "help")
//            print(data)
//        } catch {
//            print("Error failed")
//        }

//        let storageAdapter = FirebaseStorageAdapter()

//        let oldURL = storageAdapter.getDocumentsDirectoryPath().appendingPathComponent("testfile.txt")
//        do {
//            try "Sample text".write(to: oldURL, atomically: true, encoding: .utf8)
//            storageAdapter.uploadFile(from: oldURL, to: "recordings/sample_text.txt")
//        } catch {
//            print("Could not write file to documents directory")
//        }

        //reading
//        let oldURL = storageAdapter.getDocumentsDirectoryPath().appendingPathComponent("downloaded.txt")
//         storageAdapter.downloadFile(from: "recordings/sample_text.txt", localFilePath: oldURL)
//
//        do {
//            let text2 = try String(contentsOf: oldURL, encoding: .utf8)
//            print("Contents are: \(text2)")
//        }
//        catch {/* error handling here */}

        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        splitViewController?.presentsWithGesture = false
    }
}
