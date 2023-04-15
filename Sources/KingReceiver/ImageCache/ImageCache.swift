//
//  ImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/**
 이미지 캐시를 나타내는 인터페이스입니다.
 */
public protocol ImageCache {
    /**
     주어진 URL 을 통해 이미지를 요청하고 해당 데이터를 처리할 수 있는 closure 구문을 사용할 수 있습니다.
     
     - Parameters:
        - url: 이미지 데이터가 저장된 서버 URL 입니다.
        - completion: 서버로부터 전달받은 이미지 데이터를 처리할 수 있는 closure 구문입니다.
     */
    func fetch(with url: URL, completion: @escaping (Data?) -> Void)
}

extension ImageCache {
    /**
     실제로 이미지 데이터를 서버에 요청하는 기본 구현이 포함된 메소드입니다.
     
     - Parameters:
        - url: 이미지 데이터가 저장된 서버 URL 입니다.
        - etag: 서버에서 이미지 데이터가 변경되었는지 확인할 때 사용하는 ETag 입니다.
        - completion: 서버로부터 전달받은 이미지 데이터를 처리할 수 있는 closure 구문입니다.
     */
    func fetchImageData(url: URL, etag: String? = nil, completion: @escaping (ImageResponse) -> Void) {
        // request 생성
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        // etag 를 request header 에 포함
        if let etag {
            request.addValue(etag, forHTTPHeaderField: "If-None-Match")
        }

        // 이미지 데이터 요청
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

