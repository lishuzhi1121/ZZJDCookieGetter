//
//  ZZStringExts.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa

extension String {
    
    func urlEncoded() -> String? {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
                    .urlQueryAllowed)
        return encodeUrlString
    }
    
    func urlDecoded() -> String? {
        return self.removingPercentEncoding
    }
    
}
