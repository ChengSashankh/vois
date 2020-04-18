//
//  Shareable.swift
//  Vois
//
//  Created by Jiang Yuxin on 15/4/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

protocol Shareable: Serializable {
    var id: String? { get set }
    func upload() -> String?
}
