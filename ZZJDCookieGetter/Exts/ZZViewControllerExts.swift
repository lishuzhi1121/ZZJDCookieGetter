//
//  ZZViewControllerExts.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa

extension NSViewController {
    
    func showInWindow(_ sender: Any?, center: Bool = false, title: String? = nil, identifier: String? = nil) {
        let window = NSWindow(contentViewController: self)
        if let identifier = identifier {
            window.identifier = NSUserInterfaceItemIdentifier(identifier)
        }
        if let title = title {
            window.title = title
        }
        let windowController = NSWindowController(window: window)
        if center {
            if let senderViewController = sender as? NSViewController,
                let senderFrame = senderViewController.view.window?.frame {
                let windowFrame = window.frame
                let newX = senderFrame.origin.x + windowFrame.size.width * 0.5
                let newY = senderFrame.origin.y + windowFrame.size.height * 0.5
                let newFrame = NSRect(origin: CGPoint(x: newX, y: newY), size: windowFrame.size)
                window.setFrame(newFrame, display: true)
            }
        }
        windowController.showWindow(sender)
    }
    
}
