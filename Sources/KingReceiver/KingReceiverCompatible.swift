//
//  File.swift
//  
//
//  Created by 장재훈 on 2022/12/20.
//

import Foundation

/// KingReceiver 와 호환 가능한 메소드들을 사용할 수 있도록 하는 타입
/// Kingfisher 의 경우 `.kf` 를 사용하듯이 해당 모듈에서는 `.kr` 사용
/// 해당 protocol 의 extension 에서 구현됨
public protocol KingReceiverCompatible: AnyObject {}

extension KingReceiverCompatible {
    public var kr: KingReceiverWrapper<Self> {
        KingReceiverWrapper(self)
    }
}
