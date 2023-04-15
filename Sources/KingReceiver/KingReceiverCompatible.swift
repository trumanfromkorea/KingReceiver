//
//  File.swift
//
//
//  Created by 장재훈 on 2022/12/20.
//

import Foundation

/**
 KingReceiver 와 호환 가능한 메소드들을 사용할 수 있도록 하는 타입입니다.
 Kingfisher 의 경우 `.kf` 를 사용하듯이 해당 모듈에서는 `.kr` 을 사용합니다.
 */
public protocol KingReceiverCompatible: AnyObject {}

extension KingReceiverCompatible {
    /**
     해당 라이브러리 기능을 간편하게 사용할 수 있도록 해주는 프로퍼티입니다.
     */
    public var kr: KingReceiverWrapper<Self> {
        KingReceiverWrapper(self)
    }
}
