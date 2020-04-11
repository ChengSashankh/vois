//
//  RecordingStorage.swift
//  Vois
//
//  Created by Jiang Yuxin on 10/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class RecordingStorage {
    let localStorage: PerformanceFilesDirectory
    let userName: String

    init(userName: String) {
        self.userName = userName
        localStorage = PerformanceFilesDirectory(userName: userName)
    }

    func getNewRecordingFilePath() -> URL? {
        return localStorage.generateNewRecordingUrl()
    }

    func removeRecording(at url: URL) throws {
        try localStorage.removeRecording(at: url)
    }

    func convertToRelativeUrl(url: URL) -> URL {
        localStorage.getRelativeUrl(of: url)
    }

    func convertToAbsoluteUrl(url: URL) -> URL {
        localStorage.getAbsoluteUrl(of: url)
    }

    func cleanUpRecordingsAccordingTo(data: [URL]) {
        let urlPaths = data.map { $0.path }
        for recordingUrl in localStorage.getAllRecordingUrls() {
            if !urlPaths.contains(recordingUrl.path) {
                try? localStorage.removeRecording(at: recordingUrl)
            }
        }
    }
}
