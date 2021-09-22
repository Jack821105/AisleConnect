//
//  FileDataCacheBase.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/14.
//

import Foundation

/// 檔案快取
class FileDataCacheBase<T> where T: Codable {
    
    typealias CacheData = T
    
    var config: FileDataCacheConfig
    
    private var fileName: String
    
    var pathUrl: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }
    
    /// 資料時間
    private var dataTime: Date?
    
    private var dataCache: CacheData?
    
    init(config: FileDataCacheConfig, fileName: String) {
        self.config = config
        self.fileName = fileName
    }
    
    func replace(data: CacheData) {
        dataCache = data
        if let time = dataTime {
            saveFile(data: data, time: time)
        }
    }
    
    func set(data: CacheData, time: Date) {
        dataTime = time
        dataCache = data
        saveFile(data: data, time: time)
    }
    
    func getDataCache() -> (Date, CacheData)? {
        guard let dataTime = dataTime, let dataCache = dataCache else {
            return nil
        }
        return (dataTime, dataCache)
    }
    
    func readFile() {
        guard let dic = NSDictionary(contentsOf: pathUrl) as? [String: String] else {return}
        guard let dataStr = dic["data"],
            let time = Double(dic["time"] ?? "") else {
                return
        }
        dataCache = dataStr.convert(to: T.self)
        dataTime = Date(timeIntervalSince1970: time)
    }
    
    func clear() {
        dataTime = nil
        dataCache = nil
        let saveData: [String: String] = [:]
        (saveData as NSDictionary).write(to: pathUrl, atomically: true)
    }
    
    private func saveFile(data: CacheData, time: Date) {
        let saveData: [String: String] = [
            "data": data.string ?? "",
            "time": "\(time.timeIntervalSince1970)"
        ]
        (saveData as NSDictionary).write(to: pathUrl, atomically: true)
    }

    func needReloadData(dataTime: Date) -> Bool {
        if let cacheTime = config.cacheTime {
            return needReloadCacheTimeStrategy(cacheTime: cacheTime, dataTime)
        } else {
            return needReloadArrayStrategy(dataTime)
        }
    }
    
    /// cacheTime 策略
    private func needReloadCacheTimeStrategy(cacheTime: Double, _ dataTime: Date) -> Bool {
        let deadline = dataTime.timeIntervalSince1970 + cacheTime
        return Date().timeIntervalSince1970 > deadline
    }
    
    /// reloadArray 策略
    private func needReloadArrayStrategy(_ dataTime: Date) -> Bool {
        let calendar = Calendar(identifier: .iso8601)
        let dataComponents = calendar.dateComponents(in: TimeZone.taiwanTimeZone, from: dataTime)
        let nowComponents = calendar.dateComponents(in: TimeZone.taiwanTimeZone, from: Date())
        if calendar.isDateInToday(dataTime) == false {
            return true
        }
        
        let dataTime = ReloadTime(hour: dataComponents.hour ?? 0, min: dataComponents.minute ?? 0)
        let nowTime = ReloadTime(hour: nowComponents.hour ?? 0, min: nowComponents.minute ?? 0)
        let times = config.reloadTimes.sorted {$0 < $1}
        var needReload = false
        for time in times {
            let nowOverTime = (nowTime >= time)
            let dataOverTime = (dataTime >= time)
            if nowOverTime != dataOverTime {
                needReload = true
            }
        }
        return needReload
    }
    
}
