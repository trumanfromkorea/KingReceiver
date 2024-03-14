//
//  MemoryImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/// 메모리 -> `NSCache` 에 캐싱
public final class MemoryImageCache: ImageCache {
    private let cache = NSCache<NSString, NSData>()

    init(cacheLimit: Int = 52428800) {
        
        self.cache.totalCostLimit = cacheLimit
    }
    
    override func getCachedData(from url: URL) -> Data? {
        
        return self.cache[url] as? Data
    }

    override func save(image: CachableImage, with url: URL) {
        
        self.cache[url] = image.imageData as NSData
        UserDefaults.standard[url.absoluteString] = image.etag
    }
}
