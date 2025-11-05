//
//  ZZMainWindowController.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa

class ZZMainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        
        let webViewController = ZZWebViewController()
        let containerViewController = ZZContainerViewController()
        webViewController.webDelegate = containerViewController
        containerViewController.containerDelegate = webViewController
        
        let splitViewController = ZZSplitViewController()
        splitViewController.addSplitViewItem(NSSplitViewItem(viewController: webViewController))
        splitViewController.addSplitViewItem(NSSplitViewItem(viewController: containerViewController))
        contentViewController = splitViewController
    }
    
    convenience init() {
        self.init(windowNibName: NSNib.Name(String(describing: Self.self)))
    }
    
}
