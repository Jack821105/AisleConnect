//
//  FileDataProviderBase.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/14.
//

import Foundation

protocol FileDataProvider {
    func updateCacheIfNeed(complete: @escaping () -> ())
}

/// 拉整張表(所有股票的資訊) 存起來 一天更新數次
class FileDataProviderBase<T>: FileDataProvider where T: Codable {
    
    typealias CacheData = T
    
    var fileName: String {
        "FileDataCacheBase_\(type(of: self))"
    }
    
    var needGuidCache: Bool {
        return false
    }
    
    lazy var cache: FileDataCacheBase<CacheData> = {
            return FileDataCacheBase(config: config, fileName: fileName)
    }()
    
    var config: FileDataCacheConfig {
        return FileDataCacheConfig(reloadTimes: [
            ReloadTime(hour: 8, min: 30),
            ReloadTime(hour: 18, min: 30),
            ReloadTime(hour: 21, min: 30)
        ])
    }
    
    private var isLoading = false
    
    private var callbackList: [((Result<CacheData, Error>) -> Void)] = []
    
    private let getDataQueue = DispatchQueue.init(label: "FileDataProviderBase_getDataQueue")
    
    func updateCacheIfNeed(complete: @escaping () -> ()) {
        getData { (_) in
            complete()
        } errorHandler: { (_) in
            complete()
        }
    }
    
    func updateCache(callback: @escaping ((CacheData)->Void), errorHandler: @escaping ((Error)->Void)) {
        fatalError("updateCache() cannot be called on FileDataCacheBase")
    }
    
    func getData(callback: @escaping ((CacheData)->Void), errorHandler: @escaping ((Error)->Void)) {
        Logger.log("[CacheProvider] \(type(of: self)) 要求資料")
        getDataQueue.async {
            let cacheModel = self.cache
            if let (dataTime, cacheData) = cacheModel.getDataCache(),
               cacheModel.needReloadData(dataTime: dataTime) == false {
                Logger.log("[CacheProvider] \(type(of: self)) 回傳記憶體資訊")
                callback(cacheData)
                return
            }
            cacheModel.readFile()
            if let (dataTime, cacheData) = cacheModel.getDataCache(),
               cacheModel.needReloadData(dataTime: dataTime) == false {
                Logger.log("[CacheProvider] \(type(of: self)) 回傳檔案資訊")
                callback(cacheData)
                return
            }
            self.request(callback: callback, errorHandler: errorHandler)
        }
    }
    
    private func request(callback: @escaping ((CacheData)->Void), errorHandler: @escaping ((Error)->Void)) {
        let cacheModel = self.cache
        guard self.isLoading == false else {
            let block: ((Result<CacheData, Error>) -> Void) = {(result) in
                switch result {
                case .success(let info):
                    callback(info)
                case .failure(let error):
                    errorHandler(error)
                }
            }
            self.callbackList.append(block)
            return
        }
        self.isLoading = true
        
        Logger.log("[CacheProvider] \(type(of: self)) 發出Request")
        self.updateCache(callback: {data in
            let date = Date()
            cacheModel.set(data: data, time: date)
            callback(data)
            self.getDataQueue.async {
                self.isLoading = false
                for callback in self.callbackList {
                    callback(.success(data))
                }
                self.callbackList.removeAll()
            }
        }, errorHandler: {error in
            errorHandler(error)
            self.getDataQueue.async {
                self.isLoading = false
                for callback in self.callbackList {
                    callback(.failure(error))
                }
                self.callbackList.removeAll()
            }
        })
        
    }
    
}
