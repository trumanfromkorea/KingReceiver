//
//  DiskImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/// 디스크에 이미지를 캐싱합니다. 이미지는 Caches 폴더에 저장됩니다.
public final class DiskImageCache: ImageCache {
    private let userDefaults = UserDefaults.standard

    public func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        let path = path(for: url)

        if let cacheData = try? Data(contentsOf: path),
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
            return
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

    /// url 그대로 파일명 삼아 캐싱
    private func path(for url: URL) -> URL {
        let cacheDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let fileName = url.absoluteString.replacingOccurrences(of: "/", with: "_")
        
        return cacheDirectory.addPaths([fileName]) ?? url
    }

    private func save(image: CachableImage, with url: URL) {
        let path = path(for: url)
        try? image.imageData.write(to: path)
        userDefaults[url.absoluteString] = image.etag
    }
}
