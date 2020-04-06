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
    public var textComments: [[String: Any]] = [[String: Any]]()
    private var listener : ListenerRegistration!


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
        } catch {
            print("Database connection setup failed")
        }
    }

    func setUpConnection() throws {
        self.listener = query?.addSnapshotListener {(documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }

            print("Printing snapshot documents: \(snapshot.documents)")

            let results = snapshot.documents.map { document -> [String: Any] in
                if document.data() != nil {
                    return document.data()
                } else {
                    fatalError("Unable to initialize type \(TextComment.self) with dictionary \(document.data())")
                }
            }

            self.textComments = results
            self.documents = snapshot.documents

            print(self.textComments)
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

    func readObject(inCollection: String, withId: String) throws -> [String: Any] {
        let documentReference = connection.collection(inCollection).document(withId)
        var documentData = [String: Any]()

        documentReference.getDocument { document, error in
            if let document = document, document.exists {
                documentData = document.data() ?? [String: Any]()
            } else {
                print("Document does not exist")
            }
        }

        return documentData
    }

    func updateObject(inCollection: String, withId: String, newData: [String: Any]) -> String {
        let documentToUpdate = connection.collection(inCollection).document(withId)
        documentToUpdate.setData(newData, merge: true)
        return documentToUpdate.path
    }

    func deleteObject(inCollection: String, withId: String) {
        connection.collection(inCollection).document(withId).delete()
    }

    func query(inCollection: String, field: String, whereValueIs: Any) -> [[String: Any]] {
        var queryResults = [[String: Any]]()

        connection
            .collection(inCollection)
            .whereField(field, isEqualTo: whereValueIs)
            .getDocuments() { querySnapshot, error in
                if let error = error {
                    print("Failed due to error: \(error)")
                } else {
                    queryResults = querySnapshot!.documents.map { $0.data() }
                }
            }

        return queryResults
    }

    func query(inCollection: String, field: String, whereValueIn: [Any]) -> [[String: Any]] {
        var queryResults = [[String: Any]]()

        connection
            .collection(inCollection)
            .whereField(field, in: whereValueIn)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    // TODO Handle error
                } else {
                    queryResults = querySnapshot!.documents.map { $0.data() }
                }
        }

        return queryResults
    }

    func query(inCollection: String, field: String, whereValueLessThan: Any)  -> [[String: Any]]  {
        var queryResults = [[String: Any]]()

        connection
            .collection(inCollection)
            .whereField(field, isLessThan: whereValueLessThan)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    // TODO Handle error
                } else {
                    queryResults = querySnapshot!.documents.map { $0.data() }
                }
        }

        return queryResults
    }

    func query(inCollection: String, field: String, whereValueGreaterThan: Any)  -> [[String: Any]]  {
        var queryResults = [[String: Any]]()

        connection
            .collection(inCollection)
            .whereField(field, isGreaterThan: whereValueGreaterThan)
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    // TODO Handle error
                } else {
                    queryResults = querySnapshot!.documents.map { $0.data() }
                }
        }

        return queryResults
    }
}
