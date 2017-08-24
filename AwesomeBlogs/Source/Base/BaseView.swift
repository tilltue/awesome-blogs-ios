//
//  BaseUICollectionViewCell.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 2. 10..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import UIKit
import RxSwift

class BaseUICollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    deinit {
        log.verbose(type(of: self))
    }
}
class BaseUITableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    weak var insideEvent: PublishSubject<Any>? = nil
    
    deinit {
        log.verbose(type(of: self))
    }
}
class BaseUICollectionReusableView: UICollectionReusableView {
    var disposeBag = DisposeBag()
    deinit {
        log.verbose(type(of: self))
    }
}

class BaseUIView: UIView {
    var disposeBag = DisposeBag()
    deinit {
        log.verbose(type(of: self))
    }
}
