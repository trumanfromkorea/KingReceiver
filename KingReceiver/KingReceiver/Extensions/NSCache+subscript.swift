//
//  NSCache+subscript.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/12/19.
//

import Foundation

extension NSCache where KeyType == NSString, ObjectType == NSData {
    subscript(_ url: URL) -> NSData? {
        get {
            let key = url.absoluteString as NSString
            return object(forKey: key)
        }
        
        set {
            let key = url.absoluteString as NSString

            if let newValue {
                setObject(newValue, forKey: key)
            }
        }
    }
}

