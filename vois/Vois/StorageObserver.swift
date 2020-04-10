//
//  StorageObserver.swift
//  Vois
//
//  Created by Jiang Yuxin on 10/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

protocol StorageObserver {
    func update(performances: Performances, updateRecordings: Bool) throws
}
