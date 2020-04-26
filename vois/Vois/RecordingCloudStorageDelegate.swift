//
//  RecordingCloudStorageDelegate.swift
//  Vois
//
//  Created by Jiang Yuxin on 19/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

protocol RecordingCloudStorageDelegate {
    func upload(recording: Recording)
    func download(recording: Recording, successHandler: (()->Void)?, failureHandler: (() -> Void)?)
    func remove(recording: Recording)
    func remove(recording reference: String)
}
