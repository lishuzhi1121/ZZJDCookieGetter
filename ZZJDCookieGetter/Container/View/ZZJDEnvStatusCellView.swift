//
//  ZZJDEnvStatusCellView.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/16.
//

import Cocoa
import SnapKit

class ZZJDEnvStatusCellView: NSTableCellView {
    
    var status: Bool = true {
        didSet {
            if status {
                statusView.layer?.backgroundColor = NSColor.hex(0x2C3D0C).cgColor
                statusView.layer?.borderColor = NSColor.hex(0x4E7728).cgColor
                statusLabel.stringValue = "已启用"
                statusLabel.textColor = NSColor.hex(0x97E462)
            } else {
                statusView.layer?.backgroundColor = NSColor.hex(0x370D03).cgColor
                statusView.layer?.borderColor = NSColor.hex(0x6D180B).cgColor
                statusLabel.stringValue = "已禁用"
                statusLabel.textColor = NSColor.hex(0xEC5D58)
            }
        }
    }
    
    
    
    lazy var statusLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.textColor = NSColor.hex(0x97E462)
        return label
    }()
    
    lazy var statusView: NSView = {
        let v = NSView()
        v.wantsLayer = true
        v.layer?.backgroundColor = NSColor.hex(0x2C3D0C).cgColor
        v.layer?.borderWidth = 1.0
        v.layer?.borderColor = NSColor.hex(0x4E7728).cgColor
        v.layer?.cornerRadius = 4
        v.layer?.masksToBounds = true
        
        v.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview().inset(6)
        }
        
        return v
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
    }
    
    private func initSubviews() {
        addSubview(statusView)
        statusView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
