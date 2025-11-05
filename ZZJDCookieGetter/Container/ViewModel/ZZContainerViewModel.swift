//
//  ZZContainerViewModel.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/16.
//

import Cocoa

enum ZZJDCookiesTableColumnIdentifier: String {
    case Num = "ZZJDCookiesTableColumnNum"
    case Name = "ZZJDCookiesTableColumnName"
    case Value = "ZZJDCookiesTableColumnValue"
    case Status = "ZZJDCookiesTableColumnStatus"
    case Time = "ZZJDCookiesTableColumnTime"
}

class ZZContainerViewModel: NSObject {
    
    var envModels: [ZZEnvModel] = []
    private let dateFmt = DateFormatter()
    override init() {
        // "2025-07-18T07:01:56.258Z"
        dateFmt.dateFormat = "yyyy-MM-ddTHH:mm:ss.SSSZ"
    }
    
}

extension ZZContainerViewModel: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return envModels.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let identifier = tableColumn?.identifier else { return nil }
        let model = envModels[row]
        debugPrint("$$---> \(identifier.rawValue): \(tableView.bounds.width) - \(tableColumn?.width ?? 0)")
        let cellView = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
        let columnType = ZZJDCookiesTableColumnIdentifier(rawValue: identifier.rawValue)
        switch columnType {
        case .Num:
            cellView?.textField?.stringValue = "\(row + 1)"
        case .Name:
            if let infoCell = cellView as? ZZJDEnvCommonTextCellView {
                infoCell.titleText = model.name
                infoCell.subtitleText = model.remarks
            }
        case .Value:
            if let valueCell = cellView as? ZZJDEnvCommonTextCellView {
                valueCell.titleText = model.value
                valueCell.subtitleText = nil
            }
        case .Status:
            if let statusCell = cellView as? ZZJDEnvStatusCellView {
                statusCell.status = (model.status == 0)
            }
        case .Time:
            if let timeCell = cellView as? ZZJDEnvCommonTextCellView {
                if let updatedAt = model.updatedAt {
                    // "2025-07-18T07:01:56.258Z"
                    dateFmt.dateFormat = "yyyy-MM-ddEEEEEHH:mm:ss.SSSX"
                    if let date = dateFmt.date(from: updatedAt) {
                        // "2025-07-18 07:01:56"
                        dateFmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        timeCell.titleText = dateFmt.string(from: date)
                    } else {
                        timeCell.titleText = updatedAt
                        timeCell.subtitleText = nil
                    }
                } else {
                    timeCell.titleText = nil
                    timeCell.subtitleText = nil
                }
            }
        case nil:
            break
        }
        
        return cellView
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        let model = envModels[row]
        let nameRect = (model.name as NSString).boundingRect(with: NSSize(width: 80, height: CGFLOAT_MAX), options: .usesLineFragmentOrigin, attributes: [.font: NSFont.systemFont(ofSize: 14)])
        let noteRect = ((model.remarks ?? "") as NSString).boundingRect(with: NSSize(width: 80, height: CGFLOAT_MAX), options: .usesLineFragmentOrigin, attributes: [.font: NSFont.systemFont(ofSize: 12)])
        let infoH = nameRect.height + noteRect.height
        
        let valueRect = (model.value as NSString).boundingRect(with: NSSize(width: 230, height: CGFLOAT_MAX), options: .usesLineFragmentOrigin, attributes: [.font: NSFont.systemFont(ofSize: 14)])
        
        let maxH = max(infoH, valueRect.height)
        
        return maxH + 4.0 * 3.0
    }
    
}
