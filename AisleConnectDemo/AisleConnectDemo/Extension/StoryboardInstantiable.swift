//
//  StoryboardInstantiable.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/4.
//

import UIKit

// 紀錄Storyboard的資訊
protocol StoryboardInstantiable
{
    static var StoryboardName: String { get }
    static var StoryboardBundle: Bundle? { get }
    static var StoryboardIdentifier: String? { get }
}

// 可直接產生Storyboard+Class之後的結果
extension StoryboardInstantiable
{
    static var StoryboardName: String { return String(describing: self) }
    static var StoryboardIdentifier: String? { return String(describing: self) }
    static var StoryboardBundle: Bundle? { return nil }
    
    static func instantiate() -> Self
    {
        let storyboard = UIStoryboard(name: StoryboardName, bundle: StoryboardBundle)
        
        if let storyboardIdentifier = StoryboardIdentifier
        {
            return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        }
        else
        {
            return storyboard.instantiateInitialViewController() as! Self
        }
    }
}
