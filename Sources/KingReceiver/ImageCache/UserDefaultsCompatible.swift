//
//  UserDefaultsCompatible.swift
//  
//
//  Created by jisu on 3/16/24.
//

import Foundation

/// UserDefaults에 저장될 수 있는 타입

protocol UserDefaultsCompatible {}

extension NSData: UserDefaultsCompatible {}
extension NSString: UserDefaultsCompatible {}
extension NSNumber: UserDefaultsCompatible {}
extension NSDate: UserDefaultsCompatible {}
extension NSArray: UserDefaultsCompatible {}
extension NSDictionary: UserDefaultsCompatible {}
extension Data: UserDefaultsCompatible {}
