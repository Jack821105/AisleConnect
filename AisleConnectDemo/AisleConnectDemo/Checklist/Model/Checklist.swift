//
//  Checklist.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/14.
//

import Foundation

/// 書本清單資料
struct Checklist: Codable {
    
    /// 資料串
    let data: [BookList]
    
}


/// 書本清單
struct BookList: Codable {
    
    /// 名稱
    let name: String
    
    /// 產品
    let products: [Product]?
    
    init(name: String, products: [Product]?) {
        self.name = name
        self.products = products
    }
    
}


/// 產品
struct Product: Codable {
    
    /// 產品名稱
    let name: String?
    
    /// 圖片Url
    let imageUrl: String?
    
    /// 作者
    let authors: [String]?
    
    init(name: String, imageUrl: String?, authors: [String]) {
        self.name = name
        self.imageUrl = imageUrl
        self.authors = authors
    }
}
