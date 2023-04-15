//
//  File.swift
//
//
//  Created by 장재훈 on 2023/04/08.
//

import Foundation

extension URL {
    /**
     URL 에 path 를 추가해 새로운 URL 을 리턴합니다.

     - Parameters:
        - paths: URL path 들을 저장한 String Array 입니다.
     - Returns: 성공 시 path 를 추가한 URL 을, 실패 시 `nil` 을 리턴합니다.
     */
    func addPaths(_ paths: [String]) -> URL? {
        let urlString = absoluteString + "/" + paths.joined(separator: "/")

        return .init(string: urlString)
    }
}
