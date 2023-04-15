//
//  ImageResponse.swift
//
//
//  Created by 장재훈 on 2022/12/28.
//

import Foundation

/**
 이미지 요청에 대한 응답의 case 들입니다.
 */
enum ImageResponse {
    /// 이미지를 성공적으로 받아온 경우 ``CachableIamge`` 타입 인스턴스를 포함합니다.
    case fetchImage(image: CachableImage)
    /// 서버에서 이미지 데이터가 변경되지 않은 경우입니다.
    case notModified
    /// 서버로부터 유효하지 않은 응답이 도착한 경우입니다.
    case invalidResponse
    /// 서버로부터 도착한 데이터가 유효하지 않은 경우입니다.
    case invalidData
}
