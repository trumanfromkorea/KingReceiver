//
//  ImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

public protocol ImageCache {
    func fetch(with url: URL, completion: @escaping (Data?) -> Void)
}

extension ImageCache {
    func fetchImageData(with url: URL, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            completion(data)
        }
    }

    func imageRequest(url: URL, etag: String? = nil, completion: @escaping (ImageResponse) -> Void) {
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

enum ImageResponse {
    case fetchImage(image: CachableImage)
    case notModified

    case invalidResponse
    case invalidData
}
