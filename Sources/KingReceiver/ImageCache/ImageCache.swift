//
//  ImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

public class ImageCache: NSObject {
    
    func getCachedData(from url: URL) -> Data? { }
    
    func save(image: CachableImage, with url: URL) { }
    
    func fetch(with url: URL, completion: @escaping (Data?) -> Void) { 
        
        let cachedData = self.getCachedData(from: url)
        let etag: String? = UserDefaults.standard[url.absoluteString]

        self.fetchImageData(url: url, etag: etag) { [weak self] response in
            switch response {
            case let .fetchImage(image):
                self?.save(image: image, with: url)
                completion(image.imageData)
                
            case .notModified:
                completion(cachedData)
                
            default:
                completion(nil)
            }
        }
    }
    
    func fetchImageData(url: URL, etag: String? = nil, completion: @escaping (ImageResponse) -> Void) {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        if let etag {
            request.addValue(etag, forHTTPHeaderField: "If-None-Match")
        }

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
