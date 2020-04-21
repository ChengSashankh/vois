//
//  RecordingCloudStorage.swift
//  Vois
//
//  Created by Jiang Yuxin on 19/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class RecordingCloudStorage: RecordingCloudStorageDelegate {
    let cloud = FirebaseStorageAdapter()
    private let recordingExtension = ".m4a"

    func upload(recording: Recording) {
        guard let reference = recording.id else {
            return
        }
        cloud.uploadFile(from: recording.filePath, to: reference + recordingExtension)
    }

    func download(recording: Recording,
                  successHandler: (() -> Void)? = nil, failureHandler: (() -> Void)? = nil) {
        guard let reference = recording.id else {
            return
        }
        cloud.downloadFile(from: reference + recordingExtension,
                           localFilePath: recording.filePath, successHandler: successHandler, failureHandler: failureHandler)
    }

    func remove(recording: Recording) {
        guard let reference = recording.id else {
            return
        }
        cloud.deleteFile(at: reference + recordingExtension)
    }

    func remove(recording reference: String) {
        cloud.deleteFile(at: reference + recordingExtension)
    }
}
