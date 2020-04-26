//
//  RecordingTable.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 21/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class RecordingTable {/*
    private static var recordings = [String: Recording]()

    static func saveRecordingsToStorage() throws {
        let baseDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        for (fileName, recording) in recordings {
            let name = getNameWithoutExtension(fileName: fileName)
            let jsonFileURL = baseDirectory.appendingPathComponent(name).appendingPathExtension("json")
            if FileManager.default.fileExists(atPath: jsonFileURL.path) {
                try FileManager.default.removeItem(at: jsonFileURL)
            }
            let commentString = recording.getTextComments()
            var newString = ""
            for comment in commentString {
                newString += comment.text
                newString += "\n"
            }
            //print(newString)
            let data = Data(base64Encoded: newString)
            FileManager.default.createFile(atPath: jsonFileURL.path, contents: data, attributes: nil)
        }
    }

    private static func getNameWithoutExtension(fileName: String) -> String {
        let index = fileName.firstIndex(of: ".")!
        return String(fileName.prefix(upTo: index))
    }

    static func addRecording(name: String, recording: Recording) {
        recordings[name] = recording
    }

    static func addTextComment(nameOfRecording: String, comment: TextComment) {
        recordings[nameOfRecording]?.addTextComment(textComment: comment)
    }

    static func getTextComments(nameOfRecording: String) -> [TextComment] {
        guard let recording = recordings[nameOfRecording] else {
            return []
        }

        return recording.getTextComments()
    }*/
}
