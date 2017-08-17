//
//  BlogFeedCellViewModel.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 18..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit
import RxDataSources

struct BlogFeedCellViewModel: RxTableCellViewModel {
    enum CellType {
        case tableCell(entry: Entry)
        case rectangle(entry: Entry)
        case circle(entry: Entry)
        case diagonal(entries: [Entry])
        case table(entries: [Entry])
        var entries: [Entry] {
            switch self {
            case .rectangle(let entry):
                return [entry]
            case .circle(let entry):
                return [entry]
            case .diagonal(let entries):
                return entries
            case .table(let entries):
                return entries
            case .tableCell(let entry):
                return [entry]
            }
        }
        var identity: String {
            return self.entries.first?.title ?? ""
        }
        var cellIdentifier: String {
            switch self {
            case .rectangle(entry: _):
                return "BlogFeedCell_Rectangle"
            case .circle(entry: _):
                return "BlogFeedCell_Circle"
            case .diagonal(entries: _):
                return "BlogFeedCell_Diagonal"
            case .table(entries: _):
                return "BlogFeedCell_Table"
            case .tableCell(entry: _):
                return "BlogFeedCell_TableCell"
            }
        }
    }
    
    init(cellType: CellType) {
        self.identity = cellType.identity
        self.cellType = cellType
    }
    
    //MARK: - RxTableCellViewModel protocol
    static var cellNibSet = ["BlogFeedCell_Rectangle","BlogFeedCell_Circle","BlogFeedCell_Diagonal","BlogFeedCell_Table","BlogFeedCell_TableCell"]
    var identity: String
    var cellType: CellType
    
    func cellFactory(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let identifier = self.cellType.cellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! BlogFeedCell
        switch self.cellType {
        case .rectangle(let entry):
            break
        case .circle(let entry):
            let cell = cell as! BlogFeedCell_Circle
            break
        case .diagonal(let entries):
            break
        case .table(let entries):
            let cell = cell as! BlogFeedCell_Table
            let viewModels = entries.map{ BlogFeedCellViewModel(cellType: .tableCell(entry: $0)) }
            cell.cellViewModels.value = [AnimatableSectionModel(model: "section", items: viewModels)]
        case .tableCell(let entry):
            break
        default:
            break
        }
        cell.titleLabel?.text = self.identity
        cell.selectionStyle = .none
        return cell
    }
    
    static func ==(lhs: BlogFeedCellViewModel, rhs: BlogFeedCellViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }
}
