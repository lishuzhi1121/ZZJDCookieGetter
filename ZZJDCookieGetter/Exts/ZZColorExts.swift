//
//  ZZColorExts.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa

extension NSColor {
    
    public static func hex(_ hex: Int, alpha: CGFloat = 1.0) -> NSColor {
        let r = (CGFloat)((hex >> 16) & 0xFF) / 255.0
        let g = (CGFloat)((hex >> 8) & 0xFF) / 255.0
        let b = (CGFloat)(hex & 0xFF) / 255.0
        return NSColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
}
