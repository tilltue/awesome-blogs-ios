//
//  BlogFeedCell_Diagonal.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 18..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class BlogFeedView: BaseUIView {
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var authorDateLabel: UILabel?
    
    var entryViewModel: FeedEntryViewModel? = nil
    
    func setData(entryViewModel: FeedEntryViewModel) {
        self.entryViewModel = entryViewModel
        self.titleLabel?.text = entryViewModel.title
        self.authorDateLabel?.text = "by \(entryViewModel.author) · \(entryViewModel.updatedAt.colloquial())"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class BlogFeedCell_Diagonal: BlogFeedCell {
    @IBOutlet var diagonalView: UIView!
    @IBOutlet var topBlogFeedView: BlogFeedView!
    @IBOutlet var bottomBlogFeedView: BlogFeedView!
    
    var fillColor: UIColor = UIColor(hex: 0x1abc9c) {
        didSet {
            self.drawLayer()
        }
    }
    private var points = [CGPoint(x: 0, y: 0.55),
                          CGPoint(x: 0, y: 1),
                          CGPoint(x: 1, y: 1),
                          CGPoint(x: 1, y: 0.45)]
    
    private lazy var shapeLayer: CAShapeLayer = {
        let _shapeLayer = CAShapeLayer()
        self.diagonalView.layer.insertSublayer(_shapeLayer, at: 0)
        return _shapeLayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.diagonalView.rx.layoutSubviews.filter{ _ in
            return self.contentView.width == UIScreen.main.bounds.width
        }.take(1).subscribe(onNext: { [weak self] _ in
            self?.drawLayer()
        }).disposed(by: disposeBag)
        let topTap = self.topBlogFeedView.rxTap.map{ [weak self] _ in self?.topBlogFeedView.entryViewModel }
        let bottomTap = self.bottomBlogFeedView.rxTap.map{ [weak self] _ in self?.bottomBlogFeedView.entryViewModel }
        Observable.merge([topTap,bottomTap]).subscribe(onNext: { [weak self] entryViewModel in
            guard let entryViewModel = entryViewModel else { return }
            self?.insideEvent?.on(.next(entryViewModel))
        }).disposed(by: disposeBag)
    }
    
    private func drawLayer() {
        self.shapeLayer.fillColor = self.fillColor.cgColor
        let path = UIBezierPath()
        path.move(to: convert(relativePoint: self.points[0]))
        for point in self.points.dropFirst() {
            path.addLine(to: convert(relativePoint: point))
        }
        path.close()
        self.shapeLayer.path = path.cgPath
    }
    
    private func convert(relativePoint point: CGPoint) -> CGPoint {
        let bounds = self.diagonalView.bounds
        return CGPoint(x: point.x * bounds.width + bounds.origin.x, y: point.y * bounds.height + bounds.origin.y)
    }
}
