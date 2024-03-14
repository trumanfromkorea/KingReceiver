//
//  MemoryImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/// 앱이 실행되는 동안에만 메모리에 이미지를 캐시한다.
///
public final class MemoryImageCache: ImageCache {
    
    /// 메모리 캐시  (NSCache 사용)
    ///
    private let cache = NSCache<NSString, NSData>()

    
    /// Initializer.
    ///
    /// - Parameter cacheLimit: NSCache 의 최대 캐시 저장 용량
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
