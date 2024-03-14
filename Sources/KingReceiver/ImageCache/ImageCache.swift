//
//  ImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/// KingReceiver 에서 사용하는 ImageCache 객체.
///
public class ImageCache: NSObject {
    
    /// 주어진 url 에 대한 캐시 데이터를 반환한다.
    ///
    func getCachedData(from url: URL) -> Data? { return nil }
    
    /// 주어진 url 에 대한 이미지를 캐시한다.
    ///
    func save(image: CachableImage, with url: URL) { }
    
    /// url 을 이용하여 data 를 fetch 한다.
    ///
    func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        
        // cached data 가 있더라도 url 에 대한 이미지 수정 여부를 고려하여 etag 사용하여 무조건 요청을 한다.
        //
        let cachedData = self.getCachedData(from: url)
        let etag: String? = UserDefaults.standard[url.absoluteString]

        self.fetchImageData(url: url, etag: etag) { [weak self] response in
            
            switch response {
                
            // 이미지 response 도착한 경우.
            //
            case let .fetchImage(image):
                self?.save(image: image, with: url)
                completion(image.imageData)
            
            // url 에 대한 이미지 변화 없는 경우 캐시 데이터 전달.
            //
            case .notModified:
                completion(cachedData)
                
            default:
                completion(nil)
            }
        }
    }
    
    /// URL 에 대해 직접 이미지를 요청한다.
    ///
    internal func fetchImageData(url: URL, etag: String? = nil, completion: @escaping (ImageResponse) -> Void) {
        
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        if let etag {
            request.addValue(etag, forHTTPHeaderField: "If-None-Match")
        }

        // create data task with url request
        //
        let task = URLSession.shared.dataTask(with: request) { data, response, _ in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.invalidResponse)
                return
            }

            let statusCode = httpResponse.statusCode
            let newEtag = httpResponse.value(forHTTPHeaderField: "ETag")

            if statusCode == 304 {
                completion(.notModified)
                return
            }

            guard let data else {
                completion(.invalidData)
                return
            }

            completion(.fetchImage(image: CachableImage(imageData: data, etag: newEtag)))
        }

        task.resume()
    }
    
    
}
