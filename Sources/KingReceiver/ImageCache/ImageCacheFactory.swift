//
//  ImageCacheFactory.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

/**
 필요한 이미지 캐시 인스턴스를 생성해주는 Factory 입니다.
 */
public final class ImageCacheFactory {
    /**
     캐시 정책입니다.
     */
    @frozen public enum Policy {
        case none
        case memory
        case disk
    }

    /// 해당 클래스는 싱글톤으로 관리되지만, 외부에서 이미지 캐시를 생성하는 일을 방지하기 위해 private 접근제어자를 사용합니다.
    private static let shared = ImageCacheFactory()
    private init() {}

    /// 이미지 캐시를 사용하지 않는 경우입니다.
    private lazy var noneImageCache = NoneImageCache()
    /// 메모리를 사용하는 이미지 캐시입니다.
    private lazy var memoryImageCache = MemoryImageCache()
    /// 디스크를 사용하는 이미지 캐시입니다.
    private lazy var diskImageCache = DiskImageCache()

    /**
     캐시 정책에 따라 알맞은 이미지 캐시를 생성합니다.
     
     - Parameters:
        - policy: 캐시 정책에 따라 이미지 캐시를 생성할 수 있게 합니다.
     */
    static func make(with policy: Policy) -> ImageCache {
        switch policy {
        case .none: return Self.shared.noneImageCache
        case .memory: return Self.shared.memoryImageCache
        case .disk: return Self.shared.diskImageCache
        }
    }
}
