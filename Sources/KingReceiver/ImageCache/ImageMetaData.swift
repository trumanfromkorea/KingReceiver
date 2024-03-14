//
//  ImageMetaData.swift
//
//
//  Created by jisu on 3/14/24.
//

import Foundation

struct ImageMetaData: Codable {
    let etag: String?
    let cost: Int
    let lastAccessDate: Date
}
