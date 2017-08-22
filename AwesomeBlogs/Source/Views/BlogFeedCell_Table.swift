//
//  BlogFeedCell_Table.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 18..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

class BlogFeedCell_Table: BlogFeedCell,RxTableViewBindProtocol {
    
    var selectedCell = PublishSubject<(IndexPath, BlogFeedCellViewModel)>()
    var reloaded = PublishSubject<Void>()

    @IBOutlet var tableView: UITableView!
    typealias ModelType = BlogFeedCellViewModel
    var cellViewModels = Variable<[AnimatableSectionModel<String, BlogFeedCellViewModel>]>([])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.bindDataSource(tableView: self.tableView)
    }
}

//MARK: - UITableViewDelegate
extension BlogFeedCell_Table: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / 4
    }
}
