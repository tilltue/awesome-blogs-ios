//
//  FeedCellSnapshotTest.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 9. 8..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import XCTest
import RxSwift
import FBSnapshotTestCase
import Swinject
import ObjectMapper
import SwiftyJSON
import RxDataSources

@testable import AwesomeBlogs

class FeedCellSnapshotTest: FBSnapshotTestCase {
    
    var disposeBag: DisposeBag!
    var tableView: UITableView!
    let nibSet = [FeedCellStyle.rectangle.cellIdentifier,FeedCellStyle.circle.cellIdentifier,FeedCellStyle.diagonal.cellIdentifier,FeedCellStyle.table.cellIdentifier,FeedCellStyle.tableCell.cellIdentifier]
    var entries: [Entry]!
    override func setUp() {
        super.setUp()
        self.disposeBag = DisposeBag()
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 375, height: 600))
        for nibName in nibSet {
            let nib = UINib(nibName: nibName, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: nibName)
        }
//        self.recordMode = true
        let json = JSON(Bundle.jsonData(name: "MockEntry"))
        self.entries = try? Mapper<Entry>().mapArray(JSONObject: json["entries"].rawValue)
    }
    
    override func tearDown() {
        super.tearDown()
        Service.shared.deleteFeedCache()
    }
    
    func testBlogFeedCell_Rectangle() {
        let cellViewModel = BlogFeedCellViewModel(style: .rectangle, entries: self.entries)
        if let entryViewModel = cellViewModel.entryViewModels.first {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: FeedCellStyle.rectangle.cellIdentifier) as! BlogFeedCell_Rectangle
            cell.contentView.backgroundColor = UIColor(hex: 0x6854cb)
            cell.downText.text = entryViewModel.removeHTMLSummary
            cell.titleLabel?.text = entryViewModel.title
            cell.authorDateLabel?.text = "by \(entryViewModel.author) · \(entryViewModel.updatedAt.colloquial())"
            FBSnapshotVerifyView(cell)
        }
    }
    
    func testBlogFeedCell_Circle() {
        let cellViewModel = BlogFeedCellViewModel(style: .circle, entries: self.entries)
        if let entryViewModel = cellViewModel.entryViewModels.first {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: FeedCellStyle.circle.cellIdentifier) as! BlogFeedCell_Circle
            cell.circleView.backgroundColor = UIColor(hex: 0x6854cb)
            cell.titleLabel?.text = entryViewModel.title
            cell.authorLabel?.text = "by \(entryViewModel.author)"
            cell.dateLabel?.text = entryViewModel.updatedAt.colloquial()
            FBSnapshotVerifyView(cell)
        }
    }
    
    func testBlogFeedCell_Diagonal() {
        let cellViewModel = BlogFeedCellViewModel(style: .diagonal, entries: self.entries)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: FeedCellStyle.diagonal.cellIdentifier) as! BlogFeedCell_Diagonal
        cell.fillColor = UIColor(hex: 0x6854cb)
        cell.fillColor = UIColor(hex: 0x6854cb)
        cell.topBlogFeedView.setData(entryViewModel: cellViewModel.entryViewModels[0])
        cell.bottomBlogFeedView.setData(entryViewModel: cellViewModel.entryViewModels[1])
        FBSnapshotVerifyView(cell)
    }
    
    func testBlogFeedCell_Table() {
        let cellViewModel = BlogFeedCellViewModel(style: .table, entries: self.entries)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: FeedCellStyle.table.cellIdentifier) as! BlogFeedCell_Table
        let viewModels = cellViewModel.entryViewModels.flatMap({ (entryViewModel) -> BlogFeedCellViewModel? in
            var viewModel = BlogFeedCellViewModel(style: .tableCell, entries: [])
            viewModel.entryViewModels = [entryViewModel]
            return viewModel
        })
        cell.cellViewModels.value = [AnimatableSectionModel(model: "section\(0)", items: viewModels)]
        FBSnapshotVerifyView(cell)
    }
}
