//
//  PerformanceFilesDirectory.swift
//  Vois
//
//  Created by Jiang Yuxin on 22/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class PerformanceFilesDirectory {

    private static let performanceMetaDataFileName = "_meta-data"

    private static let recordingFileExtension = ".m4a"

    private static let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    private let userName: String

    init(userName: String) {
        self.userName = userName
    }

    private func getAllFileUrlsInDirectory(url: URL, includeDirectory: Bool, includeFile: Bool = true) -> [URL] {
        do {
            var urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            if !includeDirectory {
                urls = urls.filter { url in url.isFileURL }
            }
            if !includeFile {
                urls = urls.filter { url in !url.isFileURL }
            }
            return urls
        } catch {
            return []
        }
    }

    private func createIfNotExists(url: URL, isDirectory: Bool) -> URL? {
        do {
            if !FileManager.default.fileExists(atPath: url.path, isDirectory: nil) {
                if isDirectory {
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                }
            }
            return url
        } catch {
            return nil
        }
    }

    private func getUserRootDirectory() -> URL? {
        let userRootDirectoryUrl = PerformanceFilesDirectory.documentDirectoryURL
            .appendingPathComponent(userName, isDirectory: true)

        return createIfNotExists(url: userRootDirectoryUrl, isDirectory: true)
    }

    private func getPerformancesMetaDataFileUrl() -> URL? {
        return getUserRootDirectory()?
            .appendingPathComponent(PerformanceFilesDirectory.performanceMetaDataFileName)
    }

    func savePerformancesFile(with data: Data) throws {
        guard let url = getPerformancesMetaDataFileUrl() else {
            throw PerformanceFilesDirectoryError.unsuccessfullSaving
        }
        try data.write(to: url)
    }

    func getPerformancesFile() -> Data? {
        guard let url = getPerformancesMetaDataFileUrl(),
            let data = try? Data(contentsOf: url) else {
            return nil
        }
        return data
    }

    func removeRecording(at url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }

    private func getRecordingsDirectoryUrl() -> URL? {
        guard let url = getUserRootDirectory()?.appendingPathComponent("recordings", isDirectory: true) else {
            return nil
        }
        return createIfNotExists(url: url, isDirectory: true)
    }

    func generateNewRecordingUrl() -> URL? {
        return getRecordingsDirectoryUrl()?.appendingPathComponent(UUID().uuidString + PerformanceFilesDirectory.recordingFileExtension)
    }

    func getAllRecordingUrls() -> [URL] {
        guard let url = getRecordingsDirectoryUrl() else {
            return []
        }
        return getAllFileUrlsInDirectory(url: url, includeDirectory: false)
    }

    /*
    func saveRecording(for userName: String, performanceName: String,
                              songName: String, segmentName: String) throws {
        /*guard let url = getRecordingUrl(for: userName, performanceName: performanceName,
                                        songName: songName, segmentName: segmentName) else {
            throw PerformanceFilesDirectoryError.unsuccessfullSaving
        }

        guard let tempUrl = getTemporaryRecordingUrl(for: userName) else {
            throw PerformanceFilesDirectoryError.unsuccessfullSaving
        }*/
        do {
            //try FileManager.default.moveItem(at: tempUrl, to: url)
            let cloudFileName = UUID().uuidString + "_" + segmentName
            let firebaseStorageAdapter = FirebaseStorageAdapter()

            /*firebaseStorageAdapter.uploadFile(
                from: url,
                to: "recordings/" + cloudFileName
            )*/
        } catch {
            throw PerformanceFilesDirectoryError.unsuccessfullSaving
        }
    }*/

    static func removeAllUsers() {
        try? FileManager.default.removeItem(at: documentDirectoryURL)
    }
}

enum PerformanceFilesDirectoryError: Error {
    case emptyFileName
    case fileExists
    case unsuccessfullSaving
}
