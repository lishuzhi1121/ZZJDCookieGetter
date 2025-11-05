//
//  ZZSplitViewController.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa

final class ZZSplitView: NSSplitView {
    
    override var dividerThickness: CGFloat {
        return 0
    }
    
}

class ZZSplitViewController: NSSplitViewController {
    
    override func loadView() {
        let splitView = ZZSplitView()
        splitView.isVertical = true
        self.splitView = splitView
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func splitView(_ splitView: NSSplitView, effectiveRect proposedEffectiveRect: NSRect, forDrawnRect drawnRect: NSRect, ofDividerAt dividerIndex: Int) -> NSRect {
        return .zero
    }
    
}
