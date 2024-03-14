//
//  NoneImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/// 캐시를 사용하고 싶지 않은 경우 무조건 새로운 요청을 보낸다.
///
public final class NoneImageCache: ImageCache {
    
    override func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        
        self.fetchImageData(url: url) { response in
            
            switch response {
                
            case let .fetchImage(image):
                completion(image.imageData)
                
            default:
                completion(nil)
            }
        }
    }
}

