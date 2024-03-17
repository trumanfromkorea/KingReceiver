//
//  ImageMetaData.swift
//
//
//  Created by jisu on 3/14/24.
//

import Foundation

/// ImageCache에서 사용하는 MetaData
struct ImageMetaData: Codable {
    let key: String
    let cost: Int
    let lastAccessDate: Date
}

extension ImageMetaData {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func fromData(_ data: Data?) -> ImageMetaData? {
        guard let data else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(ImageMetaData.self, from: data)
    }
}
