//
//  LoginAPI.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/11.
//

import UIKit
import Alamofire


class LoginAPI {
    
    // MARK: - Prototype
    
    
    static let shared: LoginAPI = LoginAPI()
    
    private let urlString: String = "https://apistage2.aisleconnect.us/ac.server/oauth/token"
    
    
    
    func login(loginInfo: LoginInfo, callback: @escaping ((UserToken) -> Void), errorHandler: @escaping (() -> Void)) {
        let semaphore = DispatchSemaphore (value: 0)
        
        let parameters = "grant_type=password&username=\(loginInfo.username)&password=\(loginInfo.password)&client_id=my-client&client_secret=my-secret&scope=read"
        let postData =  parameters.data(using: .utf8)
        
        
        var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("JSESSIONID=87DF0C2A3216A7CB07ED4FAAD72B4BFE", forHTTPHeaderField: "Cookie")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                errorHandler()
                semaphore.signal()
                return
            }
            
            if let info = try? JSONDecoder().decode(UserToken.self, from: data) {
                DispatchQueue.main.async {
                    UserModel.userInfo = info
                    callback(info)
                }
            } else {
                DispatchQueue.main.async {
                    errorHandler()
                }
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    
}
