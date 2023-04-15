//
//  NoneImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/**
 캐시를 사용하지 않는 경우입니다.
 */
public final class NoneImageCache: ImageCache {
    /**
     주어진 URL 을 통해 이미지를 요청하고 해당 데이터를 처리할 수 있는 closure 구문을 사용할 수 있습니다.
     
     - Parameters:
        - url: 이미지 데이터가 저장된 서버 URL 입니다.
        - completion: 서버로부터 전달받은 이미지 데이터를 처리할 수 있는 closure 구문입니다.
     */
    public func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        // 캐시를 사용하지 않기 때문에 이미지를 서버에서 받아온 후 캐시에 저장하는 작업을 거치지 않음
        fetchImageData(url: url) { response in
            switch response {
            case let .fetchImage(image):
                completion(image.imageData)
                
            default:
                completion(nil)
            }
        }
    }
}
