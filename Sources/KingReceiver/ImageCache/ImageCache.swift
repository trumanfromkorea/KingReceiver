//
//  ImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

public protocol ImageCache {
    associatedtype T: CacheableData
    
    /// 주어진 url 에 대한 캐시 데이터를 반환한다.
    ///
    func getCachedData(from key: String) -> T?
    
    /// 주어진 url 에 대한 이미지를 캐시한다.
    ///
    func save(image: T, with key: String) throws
}

extension ImageCache {
    func metaData(for key: String, data: T) -> ImageMetaData {
        return ImageMetaData(key: key, cost: data.size(), lastAccessDate: Date())
    }
}
