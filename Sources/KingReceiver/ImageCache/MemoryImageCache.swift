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
    private let userDefaults = UserDefaults.standard

    init(cacheLimit: Int = 52428800) {
        cache.totalCostLimit = cacheLimit
    }

    public func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        if let cacheData = cache[url],
           let etag: String = userDefaults[url.absoluteString] {
            fetchImageData(url: url, etag: etag) { [weak self] response in
                switch response {
                case let .fetchImage(image):
                    self?.save(image: image, with: url)
                    completion(image.imageData)

                case .notModified:
                    completion(cacheData as Data)

                default:
                    completion(nil)
                }
            }
        } else {
            fetchImageData(url: url) { [weak self] response in
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
        cache[url] = image.imageData as NSData
        userDefaults[url.absoluteString] = image.etag
    }
}
