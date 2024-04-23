//
//  CacheableImage.swift
//
//
//  Created by 장재훈 on 2022/12/21.
//

import Foundation

/// ImageCacheService가 사용하는 객체로, CacheService에 저장되는 객체
public struct CacheableImage: CacheableData, Codable {
    public func toData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    public static func fromData(_ data: Data) throws -> CacheableImage {
        return try JSONDecoder().decode(Self.self, from: data)
    }
    
    public func size() -> Int {
        imageData.count + (etag?.data(using: .utf8)?.count ?? 0)
    }
    
    let imageData: Data
    let etag: String?
}
