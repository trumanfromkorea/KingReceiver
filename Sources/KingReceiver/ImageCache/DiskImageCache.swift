//
//  DiskImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/// Caches 폴더에 이미지 캐싱
public final class DiskImageCache: ImageCache {
    
    override func getCachedData(from url: URL) -> Data? {
        
        let path = self.path(for: url)
        let cachedData = try? Data(contentsOf: path)
        
        return cachedData
    }
    
    override func save(image: CachableImage, with url: URL) {
        
        let path = self.path(for: url)
        try? image.imageData.write(to: path)
        
        UserDefaults.standard[url.absoluteString] = image.etag
    }

    /// url 그대로 파일명 삼아 캐싱
    private func path(for url: URL) -> URL {
        
        let cacheDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let fileName = url.absoluteString.replacingOccurrences(of: "/", with: "_")
        
        return cacheDirectory.addPaths([fileName]) ?? url
    }

}
