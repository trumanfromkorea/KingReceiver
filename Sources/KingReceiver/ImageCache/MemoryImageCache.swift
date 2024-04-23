//
//  MemoryImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/// 앱이 실행되는 동안에만 메모리에 이미지를 캐시한다.
///
public final class MemoryImageCache<T: Cacheable>: ImageCache {
    
    /// 메모리 캐시  (NSCache 사용)
    ///
    private let cache = NSCache<NSString, NSData>()

    
    /// Initializer.
    ///
    /// - Parameter cacheLimit: NSCache 의 최대 캐시 저장 용량
    init(cacheLimit: Int = 52428800) {
        
        self.cache.totalCostLimit = cacheLimit
    }
    
    public func getCachedData(from key: String) -> T? {
        guard let data = cache.object(forKey: key as NSString) as? Data else { return nil }
        return try? T.fromData(data)
    }
    
    public func save(image: T, with key: String) {
        guard let data = try? image.toData() else { return }
        
        self.cache.setObject(
            data as NSData,
            forKey: key as NSString
        )
        
        UserDefaults.standard[key] = metaData(for: key, data: image).toData()
    }
}

