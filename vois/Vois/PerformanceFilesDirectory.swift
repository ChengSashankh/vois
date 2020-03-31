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

    private static let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    private static func getAllFileUrlsInDirectory(url: URL, includeDirectory: Bool, includeFile: Bool = true) -> [URL] {
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

    private static func createIfNotExists(url: URL, isDirectory: Bool) -> URL? {
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

    private static func getUserRootDirectory(for userName: String) -> URL? {
        let userRootDirectoryURL = PerformanceFilesDirectory.documentDirectoryURL
            .appendingPathComponent(userName, isDirectory: true)

        return createIfNotExists(url: userRootDirectoryURL, isDirectory: true)
    }

    static func getAllPerformanceFiles(for userName: String) -> [Data] {
        guard let userDirectoryURL = PerformanceFilesDirectory.getUserRootDirectory(for: userName) else {
            return []
        }

        let urls = getAllFileUrlsInDirectory(url: userDirectoryURL, includeDirectory: false)
        return urls.compactMap { url in
            PerformanceFilesDirectory.getPerformanceFile(for: userName, performanceDirectoryURL: url) }
    }

    private static func getPerformanceDirectoryUrl(for userName: String,
                                                   performanceName: String) -> URL? {
        guard let url = PerformanceFilesDirectory.getUserRootDirectory(for: userName)?
            .appendingPathComponent(performanceName, isDirectory: true) else {
            return nil
        }
        return createIfNotExists(url: url, isDirectory: true)
    }

    private static func getPerformanceFileUrl(for userName: String,
                                              performanceName: String) -> URL? {
        guard let url = getPerformanceDirectoryUrl(for: userName, performanceName: performanceName)?
            .appendingPathComponent(performanceMetaDataFileName) else {
                                                    return nil
        }
        return createIfNotExists(url: url, isDirectory: false)
    }

    private static func getPerformanceFile(for userName: String, performanceName: String) -> Data? {
        guard let url = getPerformanceFileUrl(for: userName, performanceName: performanceName) else {
                return nil
        }

        return try? Data(contentsOf: url)
    }

    static func getPerformanceFile(for userName: String, performanceDirectoryURL: URL) -> Data? {
        let url = performanceDirectoryURL
            .appendingPathComponent(PerformanceFilesDirectory.performanceMetaDataFileName)
        return try? Data(contentsOf: url)
    }

    /// Returns the file name of the given url.
    private static func getFileNameFor(url: URL?) -> String? {
        guard let fileUrl = url else {
            return nil
        }
        return fileUrl.lastPathComponent
    }

    static func savePerformanceFile(name: String, with data: Data, for userName: String) throws {
        guard let url = getPerformanceFileUrl(for: userName, performanceName: name) else {
                return
        }
        _ = createIfNotExists(url: url, isDirectory: false)

        try data.write(to: url)
    }

    private static func getSongDirectoryUrl(for userName: String, performanceName: String, songName: String) -> URL? {
        guard let url = getPerformanceDirectoryUrl(for: userName, performanceName: performanceName)?
            .appendingPathComponent(songName, isDirectory: true) else {
            return nil
        }

        return createIfNotExists(url: url, isDirectory: true)
    }

    private static func getRecordingUrl(for userName: String, performanceName: String,
                                                 songName: String, segmentName: String) -> URL? {
        guard let url = getSongDirectoryUrl(for: userName, performanceName: performanceName, songName: songName)?
            .appendingPathComponent(segmentName) else {
                return nil
        }
        return createIfNotExists(url: url, isDirectory: false)
    }

    static func getRecordingUrls(for userName: String, performanceName: String, songName: String) -> [URL] {
        guard let url = getSongDirectoryUrl(for: userName, performanceName: performanceName, songName: songName) else {
            return []
        }
        return getAllFileUrlsInDirectory(url: url, includeDirectory: false)
    }

    static func getTemporaryRecordingUrl(for userName: String) -> URL? {
        guard let url = getUserRootDirectory(for: userName)?
            .appendingPathComponent("temp.m4a") else {            return nil
        }

        return createIfNotExists(url: url, isDirectory: false)
    }

    static func removeTemporaryRecording(for userName: String)  throws {
        guard let url = getTemporaryRecordingUrl(for: userName) else {
            return
        }
        try FileManager.default.removeItem(at: url)
    }

    static func saveRecording(for userName: String, performanceName: String,
                              songName: String, segmentName: String) throws {
        guard let url = getRecordingUrl(for: userName, performanceName: performanceName,
                                                 songName: songName, segmentName: segmentName) else {
            throw PerformanceFilesDirectoryError.unsuccessfullSaving
        }

        guard let tempUrl = getTemporaryRecordingUrl(for: userName) else {
            throw PerformanceFilesDirectoryError.unsuccessfullSaving
        }
        do {
            try FileManager.default.moveItem(at: tempUrl, to: url)
        } catch {
            throw PerformanceFilesDirectoryError.unsuccessfullSaving
        }
    }

    static func removeAllUsers() {
        try? FileManager.default.removeItem(at: documentDirectoryURL)
    }
}

enum PerformanceFilesDirectoryError: Error {
    case emptyFileName
    case fileExists
    case unsuccessfullSaving
}
