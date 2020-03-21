//
//  RecordingTable.swift
//  Vois
//
//  Created by Sudharshan Madhavan on 21/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

class RecordingTable {
    static func fetchRecordings() -> [URL] {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            return fileNames
        } catch {
            return []
        }
    }
}
