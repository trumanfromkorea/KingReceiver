//
//  File.swift
//
//
//  Created by 장재훈 on 2022/12/20.
//

import Foundation

/// Compatible Types 를 위한 Wrapper
/// 모듈의 메소드들을 편리하게 사용할 수 있도록 `.kr` 과 같은 방법 제공
public struct KingReceiverWrapper<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}
