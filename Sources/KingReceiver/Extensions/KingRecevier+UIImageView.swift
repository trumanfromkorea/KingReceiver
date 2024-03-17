//
//  KingRecevier+UIImageView.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import UIKit

extension UIImageView: KingReceiverCompatible {}

public extension KingReceiverWrapper where Base: UIImageView {
    /// `UIImageView.kr.setImage` 처럼 사용 가능
    func setImage(
        with absoluteURL: String,
        placeholder: UIImage? = nil,
        indicator: UIActivityIndicatorView = UIActivityIndicatorView(),
        cachePolicy: ImageCacheFactory.Policy = .memory,
        resizing: Bool = true,
        scale: CGFloat = 1
    ) {
        guard let url = URL(string: absoluteURL) else {
            base.image = placeholder
            return
        }

        start(indicator: indicator)
        
        ImageCacheService.shared.fetch(with: url, cachePolicy: cachePolicy) { data in
            DispatchQueue.main.async {
                defer { self.stop(indicator: indicator) }

                guard let data else {
                    base.image = placeholder
                    return
                }

                if resizing {
                    base.image = UIImage.downsampling(data: data, to: base.frame.size, scale: scale)
                } else {
                    base.image = UIImage(data: data)
                }
            }
        }
    }

    func setImage(
        with data: Data,
        placeholder: UIImage? = nil,
        to targetSize: CGSize,
        scale: CGFloat = 1
    ) {
        guard let image = UIImage.downsampling(data: data, to: targetSize, scale: scale) else {
            base.image = placeholder
            return
        }

        base.image = image
    }
}

private extension KingReceiverWrapper where Base: UIImageView {
    /// 로딩 indicator 시작
    private func start(indicator: UIActivityIndicatorView?) {
        guard let indicator else {
            return
        }

        stop(indicator: indicator)

        indicator.translatesAutoresizingMaskIntoConstraints = false
        base.addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: base.topAnchor),
            indicator.bottomAnchor.constraint(equalTo: base.bottomAnchor),
            indicator.leadingAnchor.constraint(equalTo: base.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: base.trailingAnchor),
        ])

        indicator.startAnimating()
    }

    /// 로딩 indicator 종료
    private func stop(indicator: UIActivityIndicatorView?) {
        indicator?.stopAnimating()
        indicator?.removeFromSuperview()
    }
}
