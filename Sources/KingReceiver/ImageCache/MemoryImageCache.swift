//
//  MemoryImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/**
 메모리를 이용한 캐시입니다.
 */
public final class MemoryImageCache: ImageCache {
    /// URL 의 문자열을 key 로 하고 Data 를 value 로 하는 캐시 인스턴스입니다.
    private let cache = NSCache<NSString, NSData>()
    private let userDefaults = UserDefaults.standard

    /// 캐시되는 데이터의 최대값은 50MB 입니다.
    init(cacheLimit: Int = 52428800) {
        cache.totalCostLimit = cacheLimit
    }

    /**
     주어진 URL 을 통해 이미지를 요청하고 해당 데이터를 처리할 수 있는 closure 구문을 사용할 수 있습니다.

     - Parameters:
        - url: 이미지 데이터가 저장된 서버 URL 입니다.
        - completion: 서버로부터 전달받은 이미지 데이터를 처리할 수 있는 closure 구문입니다.
     */
    public func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        // 캐시 데이터가 존재하고, ETag 도 존재하는 경우
        if let cacheData = cache[url],
           let etag: String = userDefaults[url.absoluteString] {
            // ETag 를 헤더에 포함시켜 요청합니다.
            fetchImageData(url: url, etag: etag) { [weak self] response in
                switch response {
                // 이미지를 성공적으로 받아온 경우
                case let .fetchImage(image):
                    self?.save(image: image, with: url)
                    completion(image.imageData)
                    
                // 서버 이미지가 변경되지 않은 경우 -> 캐시 데이터를 사용해야 하는 경우
                case .notModified:
                    completion(cacheData as Data)
                
                default:
                    completion(nil)
                }
            }
        }
        // 이 외의 경우 새로운 이미지를 서버에 요청
        else {
            fetchImageData(url: url) { [weak self] response in
                switch response {
                // 성공적으로 받아온 경우 캐시에 저장
                case let .fetchImage(image):
                    self?.save(image: image, with: url)
                    completion(image.imageData)

                default:
                    completion(nil)
                }
            }
        }
    }

    /**
     이미지 데이터를 캐시에 저장합니다.
     
     - Parameters:
        - image: 캐시에 저장할 이미지 데이터입니다.
        - url: 캐시 데이터를 식별하는데 사용할 URL 입니다.
     */
    private func save(image: CachableImage, with url: URL) {
        cache[url] = image.imageData as NSData
        userDefaults[url.absoluteString] = image.etag
    }
}
