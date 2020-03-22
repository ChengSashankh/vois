//
//  RecordingTable.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 21/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class RecordingTable {

    private static var recordings = [String: Recording]()

    static func fetchRecordings() -> [URL] {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            addRecordingsFromURLs(fileNames)
            return fileNames
        } catch {
            return []
        }
    }

    static func addRecording(name: String, recording: Recording) {
        recordings[name] = recording
    }

    private static func addRecordingsFromURLs(_ fileNames: [URL]) {
        fileNames.forEach({ self.recordings[$0.lastPathComponent] = Recording(filePath: $0) })
    }

    static func addTextComment(nameOfRecording: String, comment: TextComment) {
        recordings[nameOfRecording]?.addTextComment(textComment: comment)
        print(recordings[nameOfRecording]?.getTextComments() ?? "")
    }

    static func getTextComments(nameOfRecording: String) -> [TextComment] {
        guard let recording = recordings[nameOfRecording] else {
            return []
        }

        return recording.getTextComments()
    }
}
