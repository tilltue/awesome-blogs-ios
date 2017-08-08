//
//  RxTableViewBindProtocol.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 8..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol RxTableCellViewModel: IdentifiableType, Equatable {
    static var cellNibSet: [String] { get set }
    var canEdit: Bool { get set }
    func cellFactory(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell
}

extension RxTableCellViewModel {
    var canEdit: Bool {
        get { return false }
        set { }
    }
}

protocol RxTableViewBindProtocol: class {
    associatedtype ModelType: RxTableCellViewModel
    var cellViewModels: Variable<[AnimatableSectionModel<String,ModelType>]> { get set }
    var selected: ((IndexPath,ModelType) -> Void)? { get set }
    var disposeBag: DisposeBag { get set }
    func bindDataSource(tableView: UITableView)
}

extension RxTableViewBindProtocol {
    
    typealias SectionModelType = AnimatableSectionModel<String,ModelType>
    var selected: ((IndexPath,ModelType) -> Void)? { get { return nil } set {} }
    
    func bindDataSource(tableView: UITableView) {
        register(tableView: tableView, nibNameSet: ModelType.cellNibSet)
        self.cellViewModels.asDriver().drive(tableView.rx.items(dataSource: createDataSource())).addDisposableTo(disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self, let selected = self.selected else { return }
            guard let sectionModel = (self.cellViewModels.value.filter{ $0.model == "section\(indexPath.section)" }.first) else { return }
            selected(indexPath, sectionModel.items[indexPath.row])
        }).addDisposableTo(disposeBag)
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self else { return }
            self.cellViewModels.value[indexPath.section].items.remove(at: indexPath.row)
        }).addDisposableTo(disposeBag)
    }
    
    private func cellViewModel(at indexPath: IndexPath) -> ModelType? {
        guard indexPath.section < self.cellViewModels.value.count else { return nil }
        guard indexPath.row < self.cellViewModels.value[indexPath.section].items.count else { return nil }
        return self.cellViewModels.value[indexPath.section].items[indexPath.row]
    }
    private func register(tableView: UITableView, nibNameSet: [String]) {
        for nibName in nibNameSet {
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: nibName)
        }
    }
    
    private func createDataSource() -> RxTableViewSectionedReloadDataSource<SectionModelType> {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModelType>()
        dataSource.configureCell = { ds, tv, ip, cellViewModel -> UITableViewCell in
            let cell = cellViewModel.cellFactory(tableView: tv, indexPath: ip)
            return cell
        }
        dataSource.canEditRowAtIndexPath = { [weak self] (ds, IndexPath) -> Bool in
            guard let `self` = self else { return false }
            return self.cellViewModels.value[IndexPath.section].items[IndexPath.row].canEdit
        }
        return dataSource
    }
}
