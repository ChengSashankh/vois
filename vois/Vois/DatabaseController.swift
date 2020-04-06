//
//  DatabaseController.swift
//  Vois
//
//  Created by Sashankh Chengavalli Kumar on 17.03.20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DatabaseController {
    var firestore = Firestore.firestore()

    func createDocument(inCollection: String, data: [String: Any]) -> String {
        let documentToAdd = firestore.collection(inCollection).document()
        documentToAdd.setData(data)
        return documentToAdd.path
    }

    func createDocument(inCollection: String, withId: String, data: [String: Any]) -> String {
        let documentToAdd = firestore.collection(inCollection).document(withId)
        documentToAdd.setData(data)
        return documentToAdd.path
    }

    func updateDocument(inCollection: String, withId: String, newData: [String: Any]) -> String {
        let documentToUpdate = firestore.collection(inCollection).document(withId)
        documentToUpdate.setData(newData, merge: true)
        return documentToUpdate.path
    }

    func deleteDocument(inCollection: String, withId: String) {
        firestore.collection(inCollection).document(withId).delete()
    }

    func getDocument(inCollection: String, withId: String) throws -> [String: Any] {
        let documentReference = firestore.collection(inCollection).document(withId)
        var documentData = [String: Any]()

        documentReference.getDocument { document, _ in
            if let document = document, document.exists {
                documentData = document.data() ?? [String: Any]()
            } else {
                print("Document does not exist")
            }
        }

        return documentData
    }

    func query(inCollection: String, field: String, whereValueIs: Any) -> [[String: Any]] {
        var queryResults = [[String: Any]]()

        firestore
            .collection(inCollection)
            .whereField(field, isEqualTo: whereValueIs)
            .getDocuments() { querySnapshot, error in
                if let error = error {
                    // TODO Handle error
                } else {
                    queryResults = querySnapshot!.documents.map { $0.data() }
                }
            }

        return queryResults
    }

    func query(inCollection: String, field: String, whereValueIn: [Any]) -> [[String: Any]] {
        var queryResults = [[String: Any]]()

        firestore
            .collection(inCollection)
            .whereField(field, in: whereValueIn)
            .getDocuments() { querySnapshot, error in
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

        firestore
            .collection(inCollection)
            .whereField(field, isLessThan: whereValueLessThan)
            .getDocuments() { querySnapshot, error in
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

        firestore
            .collection(inCollection)
            .whereField(field, isGreaterThan: whereValueGreaterThan)
            .getDocuments() { querySnapshot, error in
                if let error = error {
                    // TODO Handle error
                } else {
                    queryResults = querySnapshot!.documents.map { $0.data() }
                }
            }

        return queryResults
    }
}
