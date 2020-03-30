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

    private static func getUserRootDirectory(for userName: String) -> URL? {
        let userRootDirectoryURL = PerformanceFilesDirectory.documentDirectoryURL.appendingPathComponent(userName, isDirectory: true)

        guard FileManager.default.fileExists(atPath: userRootDirectoryURL.absoluteString, isDirectory: nil) else {
            return userRootDirectoryURL
        }
        do {
            try FileManager.default.createDirectory(at: userRootDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            return userRootDirectoryURL
        } catch {
            return nil
        }
    }

    static func getAllPerformanceFiles(for userName: String) -> [Data] {
        guard let userDirectoryURL = PerformanceFilesDirectory.getUserRootDirectory(for: userName) else {
            return []
        }

        let urls = getAllFileUrlsInDirectory(url: userDirectoryURL, includeDirectory: false)
        return urls.compactMap { url in
            PerformanceFilesDirectory.getPerformanceFile(for: userName, performanceDirectoryURL: url) }
    }

    private static func getPerformanceDirectoryUrl(for userName: String, performanceName: String) -> URL? {
        return PerformanceFilesDirectory.getUserRootDirectory(for: userName)?.appendingPathComponent(performanceName, isDirectory: true)
    }

    private static func getPerformanceFileUrl(for userName: String, performanceName: String) -> URL? {
        return getPerformanceDirectoryUrl(for: userName, performanceName: performanceName)?.appendingPathComponent(performanceMetaDataFileName)
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
        if FileManager.default.fileExists(atPath: url.absoluteString) {
            FileManager.default.createFile(atPath: url.absoluteString, contents: data, attributes: nil)
        } else {
            try data.write(to: url)
        }
    }

    private static func getSongDirectoryUrl(for userName: String, performanceName: String, songName: String) -> URL? {
        guard let url = getPerformanceFileUrl(for: userName, performanceName: performanceName)?.appendingPathComponent(songName, isDirectory: true) else {
            return nil
        }

        do {
            if !FileManager.default.fileExists(atPath: url.absoluteString) {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
            return url
        } catch {
            return nil
        }
    }

    private static func getRecordingDirectoryUrl(for userName: String, performanceName: String, songName: String, segmentName: String) -> URL? {
        return getSongDirectoryUrl(for: userName, performanceName: performanceName, songName: songName)?.appendingPathComponent(segmentName)
    }

    static func getTemporaryRecordingUrl(for userName: String) -> URL? {
        return getUserRootDirectory(for: userName)?.appendingPathComponent("temp")
    }

    static func saveRecording(for userName: String, performanceName: String, songName: String, segmentName: String) throws {
        guard let url = getRecordingDirectoryUrl(for: userName, performanceName: performanceName, songName: songName, segmentName: segmentName) else {
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
}

enum PerformanceFilesDirectoryError: Error {
    case emptyFileName
    case fileExists
    case unsuccessfullSaving
}
