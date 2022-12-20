//
//  ImageCacheFactory.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

public final class ImageCacheFactory {
    public enum Policy {
        case none
        case memory
        case disk
    }

    private static let shared = ImageCacheFactory()
    private init() {}

    private lazy var noneImageCache = NoneImageCache()
    private lazy var memoryImageCache = MemoryImageCache()
    private lazy var diskImageCache = DiskImageCache()

    static func make(with policy: Policy) -> ImageCache {
        switch policy {
        case .none: return Self.shared.noneImageCache
        case .memory: return Self.shared.memoryImageCache
        case .disk: return Self.shared.diskImageCache
        }
    }
}
