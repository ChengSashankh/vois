//
//  PerformanceFilesDirectory.swift
//  Vois
//
//  Created by Jiang Yuxin on 21/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class LevelFilesDirectory {
    private static let fileManager = FileManager.default

    private static var levelFilesDirectoryURL: URL { fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private static var fileURLs: [URL]? {
        try? fileManager.contentsOfDirectory(at: levelFilesDirectoryURL, includingPropertiesForKeys: nil)
    }

    /// Returns the file name of the given url.
    private static func getFileNameFor(url: URL?) -> String? {
        guard let fileUrl = url else {
            return nil
        }
        return fileUrl.lastPathComponent
    }

    static var fileCount: Int {
        fileURLs?.count ?? 0
    }

    static var fileNames: [String] {
        fileURLs?.compactMap { url in getFileNameFor(url: url) } ?? []
    }

    /// Returns true if the given file name exists.
    static func containsFile(name: String) -> Bool {
        let fileURL = levelFilesDirectoryURL.appendingPathComponent(name)
        return fileManager.fileExists(atPath: fileURL.path)
    }

    /// Saves file of the given name with the given data.
    /// - Throws: An Error occurs during writing to the disk.
    static func saveFile(name: String, with data: Data) throws {
        guard let fileUrl = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
            .appendingPathComponent(name) else {
                return
        }
        try data.write(to: fileUrl)
    }

    /// Returns data of file of the given name.
    static func loadFile(name: String) -> Data? {
        guard let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
            .appendingPathComponent(name) else {
                return nil
        }

        return try? Data(contentsOf: url)
    }

    /// Saves a new file of the given name with the given data.
    /// - Throws: An `LevelFilesDirectoryError` if the file name exists
    /// or the file name is empty. Otherwise, an Error occurring during writing to the disk.
    static func saveNewFile(name: String, with data: Data) throws {
        guard !name.isEmpty else {
            throw LevelFilesDirectoryError.emptyFileName
        }
        guard !containsFile(name: name) else {
            throw LevelFilesDirectoryError.fileExists
        }

        guard let fileUrl = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
            .appendingPathComponent(name) else {
                return
        }
        try data.write(to: fileUrl)
    }

    /// Deletes file of the given name.
    /// - Throws: An Error occurring during deleting.
    static func deleteFile(name: String) throws {
        let fileURL = levelFilesDirectoryURL.appendingPathComponent(name)
        try fileManager.removeItem(at: fileURL)
    }

    /// Deletes all level files.
    /// - Throws: An Error occurring during deleting.
    static func deleteAllFiles() throws {
        fileURLs?.forEach { fileUrl in try? fileManager.removeItem(at: fileUrl) }
    }
}

enum LevelFilesDirectoryError: Error {
    case emptyFileName
    case fileExists
}
