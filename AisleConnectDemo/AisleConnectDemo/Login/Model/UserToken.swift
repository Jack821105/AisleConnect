//
//  UserToken.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/11.
//

import Foundation


struct UserToken: Codable {
    
    // MARK: - Prototype
    
    let accessToken: String
    
    let tokenType: String
    
    let refreshToken: String
    
    let expiresIn: Int
    
    let scope: String
    
    
    enum CodingKeys: String, CodingKey {
    
        case accessToken = "access_token"
        
        case tokenType = "token_type"
         
        case refreshToken = "refresh_token"
        
        case expiresIn = "expires_in"
        
        case scope
         
    }
    
    // MARK: - Init
    
    init(accessToken: String, tokenType: String, refreshToken: String, expiresIn: Int, scope: String) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.scope = scope
    }
    
    
}
