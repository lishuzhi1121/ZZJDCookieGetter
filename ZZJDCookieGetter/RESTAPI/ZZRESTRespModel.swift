//
//  ZZRESTRespModel.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa

struct ZZRESTRespModel<T: Codable>: Codable {
    let code: Int
    let message: String?
    let data: T?
}

struct ZZEmptyModel: Codable {
    
}

struct ZZAuthModel: Codable {
    let token: String?
    let token_type: String?
    let expiration: TimeInterval
    
    var isEffective: Bool {
        return expiration > 0 && expiration > (Date().timeIntervalSince1970 + 300.0)
    }
    
}

struct ZZEnvModel: Codable {
    let ID: Int
    let name: String
    let value: String
    let position: Int
    let remarks: String?
    /// 状态: 0-已启用, 1-已禁用
    let status: Int
    let timestamp: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case name
        case value
        case position
        case remarks
        case status
        case timestamp
        case createdAt
        case updatedAt
    }
    
}
