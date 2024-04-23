//
//  EncodingDecodingTestCase.swift
//  
//
//  Created by jisu on 3/17/24.
//

@testable import KingReceiver
import XCTest

/// CachableData를 따르는 객체는
/// toData()와 fromData()의 구현부로 encoding/decoding을 수행하기 때문에,
/// 위 구현부가 제대로 작성되었는지 확인하기 위한 테스트 케이스
///
final class EncodingDecodingTestCase: XCTestCase {
    var dataDiskCache: DiskImageCache<Data>!
    var cacheableImageDiskCache: DiskImageCache<CacheableImage>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.dataDiskCache = DiskImageCache(cacheLimit: 100)
        self.cacheableImageDiskCache = DiskImageCache(cacheLimit: 100 * 1024)
    }
    
    override func tearDownWithError() throws {
        try? dataDiskCache.removeAll()
        try? cacheableImageDiskCache.removeAll()
        try super.tearDownWithError()
    }
    
    func testDataDecoding() {
        let data = "MockData".data(using: .ascii)!
        XCTAssertNoThrow(try dataDiskCache.save(image: data, with: "key"))
        let cachedData = self.dataDiskCache.getCachedData(from: "key")
        XCTAssertNotNil(cachedData)
        XCTAssertEqual(cachedData!, data)
    }
    
    func testCacheableImageDecoding() {
        let image = UIImage(systemName: "circle")!
        let data = CacheableImage(imageData: image.pngData()!, etag: "abc")
        try? cacheableImageDiskCache.save(image: data, with: "key")
        let cachedData = cacheableImageDiskCache.getCachedData(from: "key")
        XCTAssertNotNil(cachedData)
        XCTAssertEqual(cachedData!.etag, data.etag)
        XCTAssertTrue(cachedData!.imageData.elementsEqual(data.imageData))
    }
}
