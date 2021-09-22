//
//  StringExtensions.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/14.
//

import Foundation
import UIKit

extension String {
    
    /// Json String轉為 Decodable物件
    func convert<T: Decodable>(to type: T.Type) -> T? {
        let decoder = JSONDecoder()
        let data = self.data(using: .utf8) ?? Data()
        do {
            let result = try decoder.decode(type, from: data)
            return result
        } catch let error {
            print("[Error] convert fail \(error)")
            return nil
        }
    }
    
    /// Json String轉為 Decodable物件
    func convert<T: Decodable>(to type: T.Type, dateStrategy: JSONDecoder.DateDecodingStrategy) -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateStrategy
        let data = self.data(using: .utf8) ?? Data()
        do {
            let result = try decoder.decode(type, from: data)
            return result
        } catch let error {
            print("[Error] convert fail \(error)")
            return nil
        }
    }
    
    // 回傳index
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    // substring
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    //substring 從某個index切
    func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            
            return String(subString)
        } else {
            return self
        }
    }
    
    // 取得字串寬度
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    /// 取得文字寬度
    func getWidth(fixedHeight: CGFloat, font: UIFont) -> CGFloat {
        let boundingRect = (self as NSString).boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: fixedHeight),
                                                           options: .usesLineFragmentOrigin,
                                                           attributes: [NSAttributedString.Key.font: font],
                                                           context: nil)
        return boundingRect.size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    /// 判斷字串自訂前綴是否為數字
    func isNumber(_ prefixNumber: Int) -> Bool {
        let string = String(self.prefix(prefixNumber))
        guard let _ = Int(string) else {
            return false
        }
        return true
    }
    
    /// etf成分股，期貨id依靠正則表達式刪除多餘的內容，留下需要的部分
    mutating func replace(regex pattern: String) -> Void {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            for match in matches {
                for idx in 0..<match.numberOfRanges {
                    let rangeBounds = match.range(at: idx)
                    if let range = Range(rangeBounds, in: self) {
                        self.replaceSubrange(range, with: "")
                    }
                }
            }
        } catch {
            return
        }
    }
}
