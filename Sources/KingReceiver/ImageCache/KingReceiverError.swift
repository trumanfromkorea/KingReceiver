//
//  KingReceiverError.swift
//  
//
//  Created by jisu on 3/16/24.
//

import Foundation

enum KingReceiverError: Error {
    case cacheError(reason: KingReceiverErrorReason)
}

enum KingReceiverErrorReason {
    case failedCreatingCacheFile(at: URL)
    case failedCreatingCacheFolder(at: URL)
}
