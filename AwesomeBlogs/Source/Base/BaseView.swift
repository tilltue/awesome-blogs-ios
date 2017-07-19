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
    let disposeBag = DisposeBag()
    deinit {
        //log.verbose(type(of: self))
    }
}
class BaseUITableViewCell: UITableViewCell {
    let disposeBag = DisposeBag()
    deinit {
        //log.verbose(type(of: self))
    }
}
class BaseUICollectionReusableView: UICollectionReusableView {
    let disposeBag = DisposeBag()
    deinit {
        log.verbose(type(of: self))
    }
}

class BaseUIView: UIView {
    let disposeBag = DisposeBag()
    deinit {
        log.verbose(type(of: self))
    }
}
