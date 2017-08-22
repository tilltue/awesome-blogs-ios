//
//  RxFeedTableViewBindProtocol.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 9..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

protocol RxFeedTableViewBindProtocol: RxTableViewBindProtocol {
    var api: (() -> [(Int,[ModelType])])? { get set }
    var loadTrigger: Observable<Void>? { get set }
    func bindTrigger()
}

extension RxFeedTableViewBindProtocol {
    var api: (() -> [(Int,[ModelType])])? { get { return nil } set {} }
    var loadTrigger: Observable<Void>? { get { return nil } set {} }
    func bindTrigger() {
        self.loadTrigger?.subscribe(onNext: { [weak self]  in
            guard let `self` = self, let api = self.api else { return }
            self.cellViewModels.value = api().map{ AnimatableSectionModel(model:"section\($0.0)", items:$0.1) }
        }).disposed(by: disposeBag)
    }
}
