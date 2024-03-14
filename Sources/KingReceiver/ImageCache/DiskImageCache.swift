//
//  DiskImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/// 디스크를 이용하는 이미지 캐시
///
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

    /// 이미지 url 을 이용해 캐시 데이터를 저장할 경로를 가져온다.
    ///
    private func path(for url: URL) -> URL {
        
        // Caches 폴더에 이미지 저장.
        //
        let cacheDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let fileName = url.absoluteString.replacingOccurrences(of: "/", with: "_")
        
        return cacheDirectory.addPaths([fileName]) ?? url
    }

}
