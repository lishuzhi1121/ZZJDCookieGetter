//
//  ZZJDEnvCommonTextCellView.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/18.
//

import Cocoa
import SnapKit

class ZZJDEnvCommonTextCellView: NSTableCellView {
    
    var titleText: String? {
        didSet {
            titleLabel.stringValue = titleText ?? ""
        }
    }
    
    var subtitleText: String? {
        didSet {
            if let text = subtitleText, text.count > 0 {
                subtitleLabel.stringValue = text
                subtitleLabel.isHidden = false
//                titleLabel.snp.remakeConstraints {
//                    $0.top.equalToSuperview().offset(4)
//                    $0.leading.equalToSuperview().inset(4)
//                    $0.trailing.lessThanOrEqualToSuperview().offset(-4)
//                }
                
            } else {
                subtitleLabel.isHidden = true
//                titleLabel.snp.remakeConstraints {
//                    $0.centerY.equalToSuperview()
//                    $0.leading.equalToSuperview().inset(4)
//                    $0.trailing.lessThanOrEqualToSuperview().offset(-4)
//                }
            }
        }
    }
    
    private lazy var titleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.textColor = .white
        label.font = NSFont.systemFont(ofSize: 14)
        label.alignment = .left
        label.lineBreakMode = .byWordWrapping
        label.usesSingleLineMode = false
        label.maximumNumberOfLines = 10
        label.cell?.truncatesLastVisibleLine = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: NSTextField = {
        let label = NSTextField(labelWithString: "")
        label.textColor = .lightGray
        label.font = NSFont.systemFont(ofSize: 12)
        label.alignment = .left
        label.lineBreakMode = .byWordWrapping
        label.usesSingleLineMode = false
        label.maximumNumberOfLines = 2
        label.cell?.truncatesLastVisibleLine = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
    }
    
    func initSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.lessThanOrEqualToSuperview().offset(-4)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.lessThanOrEqualToSuperview().offset(-4)
        }
    }
    
}
