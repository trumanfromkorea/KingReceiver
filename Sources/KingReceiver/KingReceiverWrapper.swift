//
//  File.swift
//
//
//  Created by 장재훈 on 2022/12/20.
//

import Foundation

/**
 ``KingReceiverCompatible`` 타입을 위한 Wrapper 입니다. 라이브러리 기능을 편리하게 사용할 수 있도록 `.kr` 과 같은 방법을 제공합니다.
 */
public struct KingReceiverWrapper<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}
