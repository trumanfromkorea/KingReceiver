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
}
