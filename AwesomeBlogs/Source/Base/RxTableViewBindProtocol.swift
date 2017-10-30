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
    var cellIdentifier: String { get }
    var canEdit: Bool { get set }
}

extension RxTableCellViewModel {
    var canEdit: Bool {
        get { return false }
        set { }
    }
}

protocol RxTableViewBindProtocol: class {
    associatedtype ModelType: RxTableCellViewModel
    var cellNibSet: [String] { get set }
    var cellViewModels: Variable<[AnimatableSectionModel<String,ModelType>]> { get set }
    var selectedCell: PublishSubject<(IndexPath,ModelType)> { get set }
    var reloaded: PublishSubject<Void> { get set }
    var insideCellEvent: PublishSubject<Any> { get set }
    var disposeBag: DisposeBag { get set }
    func bindDataSource(tableView: UITableView)
    func createDataSource(tableView: UITableView) -> RxTableViewCustomReloadDataSource<SectionModelType>
}

extension RxTableViewBindProtocol {
    
    typealias SectionModelType = AnimatableSectionModel<String,ModelType>
    
    func bindDataSource(tableView: UITableView) {
        register(tableView: tableView, nibNameSet: self.cellNibSet)
        let dataSource = createDataSource(tableView: tableView)
        dataSource.canEditRowAtIndexPath = { [weak self] (ds, IndexPath) -> Bool in
            guard let `self` = self else { return false }
            return self.cellViewModels.value[IndexPath.section].items[IndexPath.row].canEdit
        }
        dataSource.reloadedEvent = { [weak self] in
            self?.reloaded.on(.next(()))
        }
        self.cellViewModels.asDriver().drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self else { return }
            guard let sectionModel = (self.cellViewModels.value.filter{ $0.model == "section\(indexPath.section)" }.first) else { return }
            self.selectedCell.on(.next((indexPath, sectionModel.items[indexPath.row])))
        }).disposed(by: disposeBag)
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self else { return }
            self.cellViewModels.value[indexPath.section].items.remove(at: indexPath.row)
        }).disposed(by: disposeBag)
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
}
