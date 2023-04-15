//
//  File.swift
//
//
//  Created by 장재훈 on 2023/04/08.
//

import Foundation

extension URL {
    func addPaths(_ paths: [String]) -> URL? {
        let urlString = absoluteString + "/" + paths.joined(separator: "/")

        return .init(string: urlString)
    }
}
