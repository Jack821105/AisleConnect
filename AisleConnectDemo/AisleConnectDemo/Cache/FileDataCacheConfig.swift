//
//  FileDataCacheConfig.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/14.
//

import Foundation


struct FileDataCacheConfig {
    /// 快取時間
    let cacheTime: Double?
    
    /// 重新reload的時刻
    let reloadTimes: [ReloadTime]
    
    init(cacheTime: Double) {
        self.cacheTime = cacheTime
        self.reloadTimes = []
    }
    
    init(reloadTimes: [ReloadTime]) {
        self.reloadTimes = reloadTimes
        self.cacheTime = nil
    }
    
}

extension FileDataCacheConfig {
    /// 10分鐘
    static var tenMin: FileDataCacheConfig {
        FileDataCacheConfig(cacheTime: 10 * 60)
    }
    
    /// 5分鐘
    static var fiveMin: FileDataCacheConfig {
        FileDataCacheConfig(cacheTime: 5 * 60)
    }
    
    /// 一小時
    static var oneHour: FileDataCacheConfig {
        FileDataCacheConfig(cacheTime: 60 * 60)
    }
    
    #if DEBUG
    /// 零快取
    static var zero: FileDataCacheConfig {
        FileDataCacheConfig(cacheTime: 0)
    }
    /// 10秒快取
    static var tenSec: FileDataCacheConfig {
        FileDataCacheConfig(cacheTime: 10)
    }
    #endif
    
}

struct ReloadTime: Equatable, Comparable {
    var hour: Int
    var min: Int
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.hour == rhs.hour {
            return lhs.min == rhs.min
        } else {
            return false
        }
    }
    
    static func < (lhs: ReloadTime, rhs: ReloadTime) -> Bool {
        if lhs.hour != rhs.hour {
            return lhs.hour < rhs.hour
        } else {
            return lhs.min < rhs.min
        }
    }
    
}
