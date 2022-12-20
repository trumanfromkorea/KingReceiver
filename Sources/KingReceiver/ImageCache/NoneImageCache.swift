//
//  NoneImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/// 캐싱 안할경우 그냥 ..
public final class NoneImageCache: ImageCache {
    public func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        fetchImageData(with: url, completion: completion)
    }
}
