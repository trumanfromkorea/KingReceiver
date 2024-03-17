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

    private lazy var memoryImageCache = MemoryImageCache<CachableImage>()
    private lazy var diskImageCache = DiskImageCache<CachableImage>()

    static func make(with policy: Policy) -> AnyImageCache? {
        switch policy {
        case .none: return nil
        case .memory: return AnyImageCache(Self.shared.memoryImageCache)
        case .disk: return AnyImageCache(Self.shared.diskImageCache)
        }
    }
}

struct AnyImageCache: ImageCache {
    typealias T = CachableImage
    
    private let getCachedDataClosure: (String) -> CachableImage?
    private let saveClosure: (CachableImage, String) throws -> Void
    
    init<C: ImageCache>(_ cache: C) where C.T == CachableImage {
        getCachedDataClosure = cache.getCachedData
        saveClosure = cache.save
    }
    
    func getCachedData(from key: String) -> CachableImage? {
        return getCachedDataClosure(key)
    }
    
    func save(image: CachableImage, with key: String) throws {
        try saveClosure(image, key)
    }
}
