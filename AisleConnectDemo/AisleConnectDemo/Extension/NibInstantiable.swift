//
//  NibInstantiable.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/4.
//

import UIKit

/// 紀錄Nib的資訊 用於擴充直接抓取Nib的View
public protocol NibInstantiable {
    static var nibName: String { get }
    static var nibBundle: Bundle? { get }
}

/// 可直接產生Nib bind Class之後的結果
public extension NibInstantiable {
    static var nibName: String { return String(describing: self) }
    static var nibBundle: Bundle? { return nil }
    
    static func getNib() -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    static func instantiateFirstView(owner: Any? = nil) -> Self {
        let nib = UINib(nibName: nibName, bundle: nibBundle)
        return nib.instantiate(withOwner: owner).first as! Self
    }
}

