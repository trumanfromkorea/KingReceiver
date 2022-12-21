//
//  MemoryImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/// 메모리 -> `NSCache` 에 캐싱
public final class MemoryImageCache: ImageCache {
    private let cache = NSCache<NSString, CachableImage>()

    init(cacheLimit: Int = 52428800) {
        cache.totalCostLimit = cacheLimit
    }

    public func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        if let cacheData = cache[url] {
            imageRequest(url: url, etag: cacheData.etag) { [weak self] response in
                switch response {
                case let .fetchImage(image):
                    self?.save(image: image, with: url)
                    completion(image.imageData)

                case .notModified:
                    completion(cacheData.imageData)

                default:
                    completion(nil)
                }
            }
        } else {
            imageRequest(url: url) { [weak self] response in
                switch response {
                case let .fetchImage(image):
                    self?.save(image: image, with: url)
                    completion(image.imageData)

                default:
                    completion(nil)
                }
            }
        }
    }

    private func save(image: CachableImage, with url: URL) {
        cache[url] = image
    }
}
