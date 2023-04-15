//
//  UIImage+resize.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import UIKit.UIImage

public extension UIImage {
    /**
     이미지 데이터를 원하는 크기로 다운샘플링합니다.
     
     - Parameters:
        - data: 이미지 데이터 입니다.
        - targetSize: 이미지를 해당 크기로 조정합니다.
        - scale: 이미지 다운샘플링 시 사용될 비율입니다.
     */
    static func downsampling(data: Data, to targetSize: CGSize, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
            return nil
        }

        let maxDimension = max(targetSize.width, targetSize.height) * scale
        let resizingOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension,
        ]

        guard let resizedImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, resizingOptions as CFDictionary) else {
            print("ERROR: Image Resizing Error, Check your targetSize for ImageView")
            return nil
        }

        return UIImage(cgImage: resizedImage)
    }
}
