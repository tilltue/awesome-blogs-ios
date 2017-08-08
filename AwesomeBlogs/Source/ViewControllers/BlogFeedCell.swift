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
    
    init(entry: Entry) {
        self.identity = entry.title
    }
    
    //MARK: - RxTableCellViewModel protocol
    static var cellNibSet = ["BlogFeedCell"]
    var identity: String

    func cellFactory(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogFeedCell") as! BlogFeedCell
        cell.titleLabel.text = self.identity
        return cell
    }
    
    static func ==(lhs: BlogFeedCellViewModel, rhs: BlogFeedCellViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }
}

class BlogFeedCell: BaseUITableViewCell {
    @IBOutlet var titleLabel: UILabel!
}
