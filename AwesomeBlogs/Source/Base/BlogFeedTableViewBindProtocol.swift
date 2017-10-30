//
//  BlogFeedTableViewBindProtocol.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 9. 7..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RxDataSources

protocol BlogFeedTableViewBindProtocol: RxTableViewBindProtocol {
    
}

extension BlogFeedTableViewBindProtocol {
    func createDataSource(tableView: UITableView) -> RxTableViewCustomReloadDataSource<AnimatableSectionModel<String, BlogFeedCellViewModel>> {
        let dataSource = RxTableViewCustomReloadDataSource<AnimatableSectionModel<String, BlogFeedCellViewModel>>(configureCell: { [weak self, weak tableView] ds, tv, ip, cellViewModel -> BaseUITableViewCell in
            let cell = tableView?.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier) as! BlogFeedCell
            cell.insideEvent = self?.insideCellEvent
            switch cellViewModel.style {
            case .rectangle:
                let cell = cell as! BlogFeedCell_Rectangle
                if let entryViewModel = cellViewModel.entryViewModels.first {
                    cell.contentView.backgroundColor = UIColor(hex: cellViewModel.colorCode)
                    cell.downText.text = entryViewModel.removeHTMLSummary
                    cell.titleLabel?.text = entryViewModel.title
                    cell.authorDateLabel?.text = "by \(entryViewModel.author) · \(entryViewModel.updatedAt.colloquial())"
                }
            case .circle:
                let cell = cell as! BlogFeedCell_Circle
                cell.circleView.backgroundColor = UIColor(hex: cellViewModel.colorCode)
                if let entryViewModel = cellViewModel.entryViewModels.first {
                    cell.titleLabel?.text = entryViewModel.title
                    cell.authorLabel?.text = "by \(entryViewModel.author)"
                    cell.dateLabel?.text = entryViewModel.updatedAt.colloquial()
                }
            case .diagonal:
                let cell = cell as! BlogFeedCell_Diagonal
                cell.fillColor = UIColor(hex: cellViewModel.colorCode)
                if cellViewModel.entryViewModels.count == 2 {
                    cell.topBlogFeedView.setData(entryViewModel: cellViewModel.entryViewModels[0])
                    cell.bottomBlogFeedView.setData(entryViewModel: cellViewModel.entryViewModels[1])
                }
            case .table:
                let cell = cell as! BlogFeedCell_Table
                let viewModels = cellViewModel.entryViewModels.flatMap({ (entryViewModel) -> BlogFeedCellViewModel? in
                    var viewModel = BlogFeedCellViewModel(style: .tableCell, entries: [])
                    viewModel.entryViewModels = [entryViewModel]
                    return viewModel
                })
                cell.cellViewModels.value = [AnimatableSectionModel(model: "section\(0)", items: viewModels)]
            case .tableCell:
                if let entryViewModel = cellViewModel.entryViewModels.first {
                    cell.titleLabel?.text = entryViewModel.title
                    cell.authorDateLabel?.text = "by \(entryViewModel.author) · \(entryViewModel.updatedAt.colloquial())"
                    cell.summaryLabel?.text = entryViewModel.removeHTMLSummary
                }
            }
            cell.selectionStyle = .none
            return cell
        })
        return dataSource
    }
}
