//
//  ZZRESTReqModel.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/8.
//

import Cocoa

struct ZZAddEnvModel: Codable {
    let name: String
    let value: String
    var remarks: String? = nil
}

struct ZZUpdateEnvModel: Codable {
    let ID: Int
    let name: String
    let value: String
    var remarks: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case name
        case value
        case remarks
    }
}
