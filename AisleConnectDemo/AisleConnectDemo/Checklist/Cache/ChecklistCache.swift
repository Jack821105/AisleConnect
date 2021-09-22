//
//  ChecklistCache.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/14.
//

import Foundation


class ChecklistCache: FileDataProviderBase<[BookList]> {
    
    
    static let shared: ChecklistCache = ChecklistCache()
    
    
    override var config: FileDataCacheConfig {
        .init(cacheTime: 0)
    }
    
    override func updateCache(callback: @escaping ((FileDataProviderBase<[BookList]>.CacheData) -> Void), errorHandler: @escaping ((Error) -> Void)) {
        guard let accessToken = UserModel.userInfo?.accessToken else {
            return
        }
        let requset = ChecklistAPIManger(accessToken: accessToken)
        requset.request { (info) in
            callback(info)
        } errorHandler: { (error) in
            errorHandler(error)
        }

    }
    
}
