//
//  CachableImage.swift
//
//
//  Created by 장재훈 on 2022/12/21.
//

import Foundation

/**
 캐시 가능한 이미지를 나타냅니다.
 */
struct CachableImage {
    /// 이미지 데이터입니다.
    let imageData: Data
    /// 서버 요청 간 사용할 ETag 입니다.
    let etag: String?
}
