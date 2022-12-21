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

        if let etag {
            request.setValue(etag, forHTTPHeaderField: "If-None-Match")
        }

        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.invalidResponse)
                return
            }

            let statusCode = httpResponse.statusCode

            if statusCode == 304 {
                completion(.notModified)
                return
            }

            guard let data,
                  let etag = httpResponse.value(forHTTPHeaderField: "ETag") else {
                completion(.invalidData)
                return
            }

            completion(.fetchImage(image: CachableImage(imageData: data, etag: etag)))
        }.resume()
    }
}

enum ImageResponse {
    case fetchImage(image: CachableImage)
    case notModified

    case invalidResponse
    case invalidData
}
