//
//  AppDelegate.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    lazy var mainWindow = ZZMainWindowController()
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindow.showWindow(nil)
    }

}

