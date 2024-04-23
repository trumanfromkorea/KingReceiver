//
//  DiskCacheTestCase.swift
//  
//
//  Created by jisu on 3/16/24.
//

@testable import KingReceiver
import XCTest

enum TestError: Error {
    case decodingError
    case encodingError
}

extension String: CacheableData {
    public func toData() throws -> Data {
        guard let data = self.data(using: .utf8) else { throw TestError.encodingError }
        return data
    }
    
    public func size() -> Int {
        return 1
    }
    
    public static func fromData(_ data: Data) throws -> String {
        guard let decodedData = String(data: data, encoding: .utf8) else { throw TestError.decodingError }
        return decodedData
    }
}

final class DiskCacheTestCase: XCTestCase {
    
    var stringDiskCache: DiskImageCache<String>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.stringDiskCache = DiskImageCache(cacheLimit: 3)
    }
    
    override func tearDownWithError() throws {
        try? stringDiskCache.removeAll()
        try super.tearDownWithError()
    }
    
    /// 디스크에 데이터가 잘 저장되고 가져와지는지 확인한다.
    func testDiskStoreAndGet() {
        let contents = "Hello KingReceiver!"
        let key = "TestKey"
        
        XCTAssertNil(stringDiskCache.getCachedData(from: key))
        try! stringDiskCache.save(image: contents, with: key)
        XCTAssertNotNil(stringDiskCache.getCachedData(from: key))
        let value = stringDiskCache.getCachedData(from: key)!
        XCTAssertEqual(value, contents)
    }
    
    /// 삭제가 되는지 확인한다
    func testDiskRemove() {
        let contents = "Hello KingReceiver!"
        let key = "TestKey"
        
        try! stringDiskCache.save(image: contents, with: key)
        XCTAssertNotNil(stringDiskCache.getCachedData(from: key))
        let value = stringDiskCache.getCachedData(from: key)!
        XCTAssertEqual(value, contents)
        stringDiskCache.remove(for: key)
        XCTAssertNil(stringDiskCache.getCachedData(from: key))
    }
    
    /// 전체 삭제가 수행되는지 확인한다
    func testDiskRemoveAll() {
        let keys = ["key1", "key2"]
        let contents = ["contents1", "contents2"]
        
        for (key, content) in zip(keys, contents) {
            try! stringDiskCache.save(image: content, with: key)
        }
        
        XCTAssertNoThrow(try stringDiskCache.removeAll())
        for key in keys {
            XCTAssertNil(stringDiskCache.getCachedData(from: key))
        }
    }
    
    /// 가장 마지막으로 접근된 이미지부터 제거되는지 확인한다.
    func testLRU() {
        let maxSize = stringDiskCache.cacheLimit
        XCTAssertTrue(maxSize >= 3, "LRU를 테스트하기 위해서는 maxSize를 3 이상으로 설정 필요")
        
        let keys = ["key1", "key2", "key3"]
        let contents = ["contents1", "contents2", "contents3"]
        
        for (key, content) in zip(keys, contents) {
            try! stringDiskCache.save(image: content, with: key)
        }
        
        _ = stringDiskCache.getCachedData(from: keys[0])
        _ = stringDiskCache.getCachedData(from: keys[1])
        _ = stringDiskCache.getCachedData(from: keys[0])
        
        let newKey = "key4"
        let newContent = "content4"
        
        try! stringDiskCache.save(image: newContent, with: newKey)
        
        XCTAssertNil(stringDiskCache.getCachedData(from: keys[2]))
        XCTAssertNotNil(stringDiskCache.getCachedData(from: keys[0]))
        XCTAssertNotNil(stringDiskCache.getCachedData(from: keys[1]))
        XCTAssertNotNil(stringDiskCache.getCachedData(from: newKey))
    }
    
}

/// Helper Functions
extension DiskCacheTestCase {
    
    /// 정해진 개수와 크기만큼의 Mock Image를 디스크에 저장한 후, Mock Image의 key 배열을 리턴한다.
    private func saveMockImages(count: Int, withCost cost: Int) -> [String] {
        var keys = [String]()
        
        for i in 0..<count {
            let key = String(repeating: "key", count: 20) + String(i)
            let content = String(repeating: "contents", count: 1000) + String(i)
            try! stringDiskCache.save(image: content, with: key)
            keys.append(key)
        }
        return keys
    }
}
