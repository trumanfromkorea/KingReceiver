//
//  KingRecevier+UIImageView.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import UIKit

extension UIImageView: KingReceiverCompatible {}

public extension KingReceiverWrapper where Base: UIImageView {
    /**
     `UIImageView` 인스턴스의 이미지를 설정합니다. 캐시에 이미지 데이터가 존재하는 경우 캐시 데이터를 활용하고, 그렇지 않다면 데이터를 요청 후 캐시에 저장합니다.
     
     - Parameters:
        - absoluteURL: 이미지 URL 을 나타내는 문자열입니다.
        - placeholder: 해당 이미지 뷰의 placeholder 이미지입니다.
        - indicator: 이미지를 가져오는 동안 표시할 indicator view 입니다.
        - cachePolicy: 해당 이미지 데이터를 저장하는데 사용할 캐시 정책입니다.
        - resizing: 다운샘플링 여부입니다.
        - scale: 다운샘플링 시 비율입니다.
     */
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

        let imageCache = ImageCacheFactory.make(with: cachePolicy)

        imageCache.fetch(with: url) { data in
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
    
    /**
     `UIImageView` 에서 이미지 데이터만을 가지고 이미지를 설정할 때 사용합니다. 다운샘플링을 지원합니다.
     
     - Parameters:
        - data: 이미지 데이터 입니다.
        - placeholder: 해당 이미지 뷰의 placeholder 이미지입니다.
        - scale: 다운샘플링 시 비율입니다.
     */
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
    /**
     이미지 로딩 시 표시할 indicator view 를 시작합니다.
     
     - Parameters:
        - indicator: Indicator view 입니다.
     */
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

    /**
     이미지 로딩 시 표시할 indicator view 를 중단합니다.
     
     - Parameters:
        - indicator: Indicator view 입니다.
     */
    private func stop(indicator: UIActivityIndicatorView?) {
        indicator?.stopAnimating()
        indicator?.removeFromSuperview()
    }
}
