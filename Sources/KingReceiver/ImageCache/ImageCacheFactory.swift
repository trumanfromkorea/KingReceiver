//
//  ImageCacheFactory.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

public final class ImageCacheFactory {
    @frozen public enum Policy {
        case none
        case memory
        case disk
    }

    private static let shared = ImageCacheFactory()
    private init() {}

    private lazy var memoryImageCache = MemoryImageCache<CacheableImage>()
    private lazy var diskImageCache = DiskImageCache<CacheableImage>()

    static func make(with policy: Policy) -> AnyImageCache? {
        switch policy {
        case .none: return nil
        case .memory: return AnyImageCache(Self.shared.memoryImageCache)
        case .disk: return AnyImageCache(Self.shared.diskImageCache)
        }
    }
}

struct AnyImageCache: ImageCache {
    typealias T = CacheableImage
    
    private let getCachedDataClosure: (String) -> CacheableImage?
    private let saveClosure: (CacheableImage, String) throws -> Void
    
    init<C: ImageCache>(_ cache: C) where C.T == CacheableImage {
        getCachedDataClosure = cache.getCachedData
        saveClosure = cache.save
    }
    
    func getCachedData(from key: String) -> CacheableImage? {
        return getCachedDataClosure(key)
    }
    
    func save(image: CacheableImage, with key: String) throws {
        try saveClosure(image, key)
    }
}
