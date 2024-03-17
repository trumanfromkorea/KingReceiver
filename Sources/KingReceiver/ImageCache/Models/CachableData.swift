//
//  CachableData.swift
//  
//
//  Created by jisu on 3/15/24.
//

import Foundation

/// ImageCache에 저장하는 대상이 되는 데이터
///
public protocol CachableData: Codable {
    func toData() throws -> Data
    func size() -> Int
    static func fromData(_ data: Data) throws -> Self
}

extension Data: CachableData {
    public func toData() throws -> Data {
        return self
    }
    
    public static func fromData(_ data: Data) throws -> Data {
        return data
    }
    
    public func size() -> Int {
        return self.count
    }
}
