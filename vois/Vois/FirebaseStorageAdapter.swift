//
//  FirebaseStorageAdapter.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 06.04.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseStorageAdapter {
    var storage: Storage
    var bucketName: String

    init(bucketName: String) {
        self.storage = Storage.storage()
        self.bucketName = bucketName
    }

    convenience init() {
        self.init(bucketName: "")
    }

    func getDocumentsDirectoryPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoryPath = paths[0]
        return documentDirectoryPath
    }

    func getReference(toPath: String) -> StorageReference {
        let fullPath = bucketName + "/" + toPath
        return storage.reference().child(fullPath)
    }

    func downloadFile(from: String, localFilePath: URL, successHandler: (()->Void)? = nil, failureHandler: (()->Void)? = nil) {
        let cloudFileReference = getReference(toPath: from)
        let downloadTask = cloudFileReference.write(toFile: localFilePath)

        downloadTask.observe(.success) { snapshot in
            successHandler?()
        }

        downloadTask.observe(.failure) { snapshot in
            failureHandler?()
        }
    }

    func uploadFile(from: URL, to: String) {
        let storageReference = getReference(toPath: to)

        //let storageReference = getReference(toPath: "test.m4a")
        let uploadTask = storageReference.putFile(from: from, metadata: nil)

        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                print(from)
                print(to)
                print("Failed due to error: \(error)")
            }
        }

        uploadTask.observe(.success) { snapshot in
            print("Succeded")
            print(snapshot)
        }
    }

    func deleteFile(at: String) {
        let storageReference = getReference(toPath: at)

        storageReference.delete { error in
            if let error = error {
                print("Failed due to error: \(error)")
            } else {
                print("Deleted successfully")
            }
        }
    }

    func listFiles(at: String) -> [String] {
        let storageReference = getReference(toPath: "recordings")

        var items = [String]()
        storageReference.listAll { result, error in
            if let error = error {
                print("Failed due to error: \(error)")
            } else {
                items = result.items.map { $0.name }
                print("Items found are: \(items)")
            }
        }

        return items
    }
}
