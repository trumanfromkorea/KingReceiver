//
//  File.swift
//
//
//  Created by 장재훈 on 2022/12/22.
//

import Foundation

extension UserDefaults {
    /**
     `UserDefaults` 사용 시 대괄호 문법을 지원합니다.
     */
    subscript<T>(key: String) -> T? {
        get { value(forKey: key) as? T }
        set { set(newValue, forKey: key) }
    }
}
