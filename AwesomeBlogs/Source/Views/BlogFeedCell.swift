//
//  BlogFeedCell.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 9..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit

struct BlogFeedCellViewModel: RxTableCellViewModel {
    enum CellType {
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
            }
        }
        var identity: String {
            return self.entries.first?.title ?? ""
        }
    }
    
    init(cellType: CellType) {
        self.identity = cellType.identity
        self.cellType = cellType
    }
    
    //MARK: - RxTableCellViewModel protocol
    static var cellNibSet = ["BlogFeedCell"]
    var identity: String
    var cellType: CellType
    
    func cellFactory(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogFeedCell") as! BlogFeedCell
        cell.titleLabel.text = self.identity
        cell.selectionStyle = .none
        return cell
    }
    
    static func ==(lhs: BlogFeedCellViewModel, rhs: BlogFeedCellViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }
}

class BlogFeedCell: BaseUITableViewCell {
    @IBOutlet var titleLabel: UILabel!
}
