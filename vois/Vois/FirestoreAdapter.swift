//
//  FirebaseAdapter.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 01.04.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirestoreAdapter {
    var isConnected: Bool
    var connection: Firestore

    private var documents: [DocumentSnapshot] = []
    private var listener: ListenerRegistration!

    fileprivate func baseQuery() -> Query {
        return connection.collection("comments")
    }

    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }

    init() {
        isConnected = false
        connection = Firestore.firestore()
        do {
            try setUpConnection()
            isConnected = true
        } catch {
            print("Database connection setup failed")
        }
    }

    func setUpConnection() throws {
        self.listener = query?.addSnapshotListener {documents, error in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }

            print("Printing snapshot documents: \(snapshot.documents)")

            _ = snapshot.documents.map { document -> [String: Any] in
                if document.data() != nil {
                    return document.data()
                } else {
                    fatalError("Unable to initialize type \(TextComment.self) with dictionary \(document.data())")
                }
            }

            self.documents = snapshot.documents

        }
    }

    func exampleCode() {
        let db = Firestore.firestore()
        let ref = db.collection("comments")

        ref.document("help2").setData([
            "name2": "wooohoo"
        ])
    }

    func writeObject(inCollection: String, data: [String: Any]) -> String {
        let documentToAdd = connection.collection(inCollection).document()
        documentToAdd.setData(data)
        return documentToAdd.path
    }

    func writeObject(inCollection: String, withId: String, data: [String: Any]) -> String {
        let documentToAdd = connection.collection(inCollection).document(withId)
        documentToAdd.setData(data)
        return documentToAdd.path
    }

    func readObject(inCollection: String, withId: String, _ completionHandler: (([String: Any]) -> Void)? = nil) throws {
        let documentReference = connection.collection(inCollection).document(withId)

        documentReference.getDocument { document, _ in
            var documentData = [String: Any]()
            if let document = document, document.exists {
                documentData = document.data() ?? [String: Any]()

            } else {
                print("Document does not exist")
            }
            completionHandler?(documentData)
        }

    }

    func readObject(with path: String, _ completionHandler: (([String: Any]) -> Void)? = nil) {
        let documentReference = connection.document(path)

        documentReference.getDocument { document, _ in
            var documentData = [String: Any]()
            if let document = document, document.exists {
                documentData = document.data() ?? [String: Any]()
            } else {
                print("Document does not exist")
            }
             completionHandler?(documentData)
        }
    }

    func readObject(in collection: String, _ completionHandler: (([[String: Any]]) -> Void)? = nil){
        connection.collection(collection).getDocuments { querySnapshot, err in
            var documents = [[String: Any]]()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    documents.append(document.data())
                }
            }
            completionHandler?(documents)
        }
    }

    func readObject(in collection: String, _ completionHandler: (([(String,[String: Any])]) -> Void)? = nil){
        connection.collection(collection).getDocuments { querySnapshot, err in
            var documents = [(String,[String: Any])]()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    documents.append((document.reference.path,document.data()))
                }
            }
            completionHandler?(documents)
        }
    }

    func updateObject(inCollection: String, withId: String, newData: [String: Any]) -> String {
        let documentToUpdate = connection.collection(inCollection).document(withId)
        documentToUpdate.setData(newData, merge: true)
        return documentToUpdate.path
    }

    func updateObject(with path: String, newData: [String: Any]) -> String {
        let documentToUpdate = connection.document(path)
        documentToUpdate.setData(newData, merge: true)
        return documentToUpdate.path
    }

    func deleteObject(inCollection: String, withId: String) {
        connection.collection(inCollection).document(withId).delete()
    }

    func deleteObject(with path: String) {
        connection.document(path).delete()
    }

    func query(inCollection: String, field: String, whereValueIs: Any, _ completitionHandler: ((([String: Any], String)?) -> Void)? = nil) {

        connection
            .collection(inCollection)
            .whereField(field, isEqualTo: whereValueIs)
            .getDocuments { querySnapshot, error in
                var queryResults = [[String: Any]]()
                if error != nil {
                    completitionHandler?(nil)
                } else {
                    queryResults = querySnapshot!.documents.map { $0.data() }
                    completitionHandler?(!queryResults.isEmpty ? (queryResults[0], querySnapshot!.documents[0].reference.path) : nil)
                }
            }
    }

    func query(inCollection: String, field: String, whereValueIn: [Any]) -> [[String: Any]] {
        var queryResults = [[String: Any]]()

        connection
            .collection(inCollection)
            .whereField(field, in: whereValueIn)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    // TODO Handle error
                } else {
                    queryResults = querySnapshot!.documents.map { $0.data() }
                }
            }

        return queryResults
    }

    func query(inCollection: String, field: String, whereValueLessThan: Any) -> [[String: Any]] {
        var queryResults = [[String: Any]]()

        connection
            .collection(inCollection)
            .whereField(field, isLessThan: whereValueLessThan)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    // TODO Handle error
                } else {
                    queryResults = querySnapshot!.documents.map { $0.data() }
                }
            }

        return queryResults
    }

    func query(inCollection: String, field: String, whereValueGreaterThan: Any) -> [[String: Any]] {
        var queryResults = [[String: Any]]()

        connection
            .collection(inCollection)
            .whereField(field, isGreaterThan: whereValueGreaterThan)
            .getDocuments { querySnapshot, error in
                if error != nil {
                    // TODO Handle error
                } else {
                    queryResults = querySnapshot!.documents.map { $0.data() }
                }
            }

        return queryResults
    }

    func deleteData(in collection: String) {
        connection.collection(collection).getDocuments { querySnapshot, error in
            if error != nil {
                // TODO Handle error
            } else {
                querySnapshot!.documents.forEach { self.deleteObject(with: $0.reference.path) }
            }
        }
    }
}
