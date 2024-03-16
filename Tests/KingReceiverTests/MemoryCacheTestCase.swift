//
//  MemoryCacheTestCase.swift
//  
//
//  Created by jisu on 3/17/24.
//

@testable import KingReceiver
import XCTest

final class MemoryCacheTestCase: XCTestCase {
    
    var stringDiskCache: MemoryImageCache<String>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.stringDiskCache = MemoryImageCache(cacheLimit: 3)
    }

    /// 메모리에 데이터가 잘 저장되고 가져와지는지 확인한다.
    func testDiskStoreAndGet() {
        let contents = "Hello KingReceiver!"
        let key = "TestKey"
        
        XCTAssertNil(stringDiskCache.getCachedData(from: key))
        stringDiskCache.save(image: contents, with: key)
        XCTAssertNotNil(stringDiskCache.getCachedData(from: key))
        let value = stringDiskCache.getCachedData(from: key)!
        XCTAssertEqual(value, contents)
    }
}
