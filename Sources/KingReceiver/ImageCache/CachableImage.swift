//
//  CachableImage.swift
//
//
//  Created by 장재훈 on 2022/12/21.
//

import Foundation

final class CachableImage {
    let imageData: Data
    let etag: String

    init(imageData: Data, etag: String) {
        self.imageData = imageData
        self.etag = etag
    }
}
