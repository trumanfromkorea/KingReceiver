//
//  UIImage+resize.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import UIKit.UIImage

public extension UIImage {
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
