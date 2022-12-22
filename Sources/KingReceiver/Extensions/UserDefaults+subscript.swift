//
//  File.swift
//
//
//  Created by 장재훈 on 2022/12/22.
//

import Foundation

extension UserDefaults {
    subscript<T>(key: String) -> T? {
        get { value(forKey: key) as? T }
        set { set(newValue, forKey: key) }
    }
}
