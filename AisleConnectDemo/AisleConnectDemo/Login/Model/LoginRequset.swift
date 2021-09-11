//
//  LoginRequset.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/5.
//

import Foundation


struct LoginRequset: Codable {
    let grantType: String = "password"
    let username: String
    let password: String
    let clientId: String = "my-client"
    let clientSecret: String = "my-secret"
    let scope: String = "read"
    
     enum CodingKeys: String, CodingKey {
            case grantType = "grant_type"
            case username
            case password
            case clientId = "client_id"
            case clientSecret = "client_secret"
        }
    
}


struct LoginResponse: Codable {
    let error: String
}
