//
//  TimeZoneExtension.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/14.
//

import Foundation

extension TimeZone {
    
    /// 取得台灣時區
    static var taiwanTimeZone: TimeZone {
        return TimeZone(identifier: "Asia/Taipei") ?? TimeZone(secondsFromGMT: 8 * 60 * 60) ?? TimeZone.current
    }
    
    /// 取得美股時區
    static let usTimeZone = TimeZone(abbreviation: "PDT") ?? TimeZone(secondsFromGMT: -7 * 60 * 60) ?? TimeZone.current
    
}
