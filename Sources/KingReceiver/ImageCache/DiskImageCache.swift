//
//  DiskImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/// 디스크를 이용하는 이미지 캐시
///
public final class DiskImageCache<T: CacheableData>: ImageCache {
    
    private let fileManager = FileManager.default
    private(set) var cacheLimit: Int
    private var defaultCacheDirectory: URL {
        return fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent("KingReceiver")
    }
    
    init(cacheLimit: Int = 100 * 1024 * 1024) {
        self.cacheLimit = cacheLimit
        try? prepareCacheFolder()
    }
    
    public func getCachedData(from key: String) -> T? {
        guard let path = self.path(for: key) else { return nil }
        
        do {
            let cachedData = try Data(contentsOf: path)
            let decodedData: T = try T.fromData(cachedData)
            updateLastAccessDate(for: key)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
    public func save(image: T, with key: String) throws {
        guard let path = self.path(for: key) else { return }
        do {
            try saveImageData(image: image, with: key, at: path)
        } catch {
            guard !error.isFolderMissing else {
                throw KingReceiverError.cacheError(
                    reason: .failedCreatingCacheFile(
                        at: path
                    )
                )
            }
            
            do {
                try prepareCacheFolder()
                try saveImageData(image: image, with: key, at: path)
            } catch {
                if let error = error as? KingReceiverError {
                    throw error
                }
                throw KingReceiverError.cacheError(
                    reason: .failedCreatingCacheFile(
                        at: path
                    )
                )
            }
        }
    }
    
    private func saveImageData(image: T, with key: String, at path: URL) throws {
        let encodedData = try image.toData()
        try encodedData.write(to: path)
        UserDefaults.standard[key] = metaData(for: key, data: image).toData()
        removeLeastRecentlyUsedIfNeeded()
    }
}

/// Disk Purge Functions
extension DiskImageCache {
    
    /// 가장 늦게 사용된 이미지들을 cacheLimit이하로 도달할 때까지 삭제
    /// 현재 cache사용용량이 cacheLimit보다 작은지 확인하는 기능도 포함
    func removeLeastRecentlyUsedIfNeeded() {
        if totalSize() <= cacheLimit { return }
        
        var sortedMetaData = allMetaData().sorted(by: { $0.lastAccessDate > $1.lastAccessDate })
        var currentCost = totalSize()
        
        while currentCost > cacheLimit, let metaData = sortedMetaData.popLast() {
            currentCost -= metaData.cost
            remove(for: metaData.key)
        }
    }
    
    /// key에 해당하는 캐싱된 이미지를 제거
    /// 실제 이미지와 메타데이터 모두 제거
    func remove(for key: String) {
        guard let path = self.path(for: key) else { return }
        try? fileManager.removeItem(at: path)
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    /// 캐싱된 모든 이미지를 제거
    func removeAll() throws {
        for key in fileManager.allFileNames(at: defaultCacheDirectory) {
            remove(for: key)
        }
    }
}

/// Helper Functions
extension DiskImageCache {
    /// 이미지 url 을 이용해 캐시 데이터를 저장할 경로를 가져온다.
    ///
    private func path(for key: String) -> URL? {
        let fileName = key.replacingOccurrences(of: "/", with: "_")
        return defaultCacheDirectory.appendingPathComponent(fileName)
    }
    
    /// 저장된 이미지들의 메타데이터들을 리턴
    func allMetaData() -> [ImageMetaData] {
        return fileManager.allFileNames(at: defaultCacheDirectory)
            .compactMap { (key: String) -> Data? in UserDefaults.standard[key] }
            .compactMap { ImageMetaData.fromData($0)}
    }
    
    /// 현재 저장된 모든 이미지들의 크기를 리턴한다
    /// 메타데이터에 저장된 cost들의 합을 가지고 크기를 계산한다
    func totalSize() -> Int {
        return allMetaData().reduce(0) { $0 + $1.cost }
    }
    
    /// 이미지의 가장 최근 접속 날짜를 메타데이터에 업데이트한 후 저장
    private func updateLastAccessDate(for key: String) {
        if let encodedMetaData: Data = UserDefaults.standard[key],
           let metaData = ImageMetaData.fromData(encodedMetaData) {
            
            let newMetaData = ImageMetaData(
                key: key,
                cost: metaData.cost,
                lastAccessDate: Date()
            )
            UserDefaults.standard[key] = newMetaData.toData()
        }
    }
    
    /// 캐싱할 폴더가 있는지 확인하고 없으면 폴더 생성
    private func prepareCacheFolder() throws {
        guard !fileManager.fileExists(
            atPath: defaultCacheDirectory.path
        ) else {
            return
        }
        
        do {
            try fileManager.createDirectory(
                at: defaultCacheDirectory,
                withIntermediateDirectories: true
            )
        } catch {
            throw KingReceiverError.cacheError(
                reason: .failedCreatingCacheFolder(
                    at: defaultCacheDirectory
                )
            )
        }
    }
}

fileprivate extension FileManager {
    
    /// 특정 경로 하위 모든 파일 경로들을 배열로 리턴.
    /// 하위 폴더들은 무시
    /// - Parameter url: 기준이 되는 경로
    func allPaths(at url: URL) -> [URL] {
        return (try? self.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: nil,
            options: .skipsSubdirectoryDescendants
        )) ?? []
    }
    
    /// 특정 경로 하위 모든 파일명들을 배열로 리턴.
    /// 하위 폴더들은 무시
    /// - Parameter url: 기준이 되는 경로
    func allFileNames(at url: URL) -> [String] {
        return allPaths(at: url).map { $0.lastPathComponent }
    }
}

fileprivate extension Error {
    var isFolderMissing: Bool {
        let nsError = self as NSError
        guard nsError.domain == NSCocoaErrorDomain, nsError.code == 4 else {
            return false
        }
        guard let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError else {
            return false
        }
        guard underlyingError.domain == NSPOSIXErrorDomain, underlyingError.code == 2 else {
            return false
        }
        return true
    }
}
