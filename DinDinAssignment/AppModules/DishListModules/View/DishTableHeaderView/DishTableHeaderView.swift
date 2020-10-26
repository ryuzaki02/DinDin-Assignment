//
//  DishTableHeader.swift
//  DinDinAssignment
//
//  Created by Aman on 23/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DishTableHeaderView: UIView {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var prevPage = 0
    private var bannerModelArray: [BannerModel] = []
    private let disposeBag = DisposeBag()
    private let cellIdentifier = "DishTableHeaderCollectionViewCell"

    class func instanceFromNib() -> DishTableHeaderView {
        return UINib(nibName: "DishTableHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DishTableHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialiseView()
        subscribePageControl()
    }
    
    /// To call for the first time
    override func layoutSubviews() {
        updatePageControlDot()
    }
    
    //MARK:- Inital setup
    func updateCollectionViewData(bannerModelArary: [BannerModel]?) {
        if let bannerModelArray = bannerModelArary{
            self.bannerModelArray = bannerModelArray
            pageControl.numberOfPages = bannerModelArray.count
            setupCellConfiguration()
        }
    }

    //MARK:- Initial UI methods
    private func initialiseView() {
        setupUI()
    }
    
    private func setupUI() {
        setupCollectionView()
    }
    
    /// To setup collection view
    private func setupCollectionView() {
        bannerCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bannerCollectionView.contentInsetAdjustmentBehavior = .never
        bannerCollectionView.delegate = self
        bannerCollectionView .register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
    }
    
    //MARK:- Subscribe methods
    
    /// To Update page control current page with scroll of main banner collection view
    private func subscribePageControl() {
        bannerCollectionView.rx.currentPage
        .subscribe(onNext: { [weak self] in
            guard let weakSelf = self
                else{return}
            weakSelf.pageControl.currentPage = $0
            weakSelf.pageControl.subviews[weakSelf.prevPage].transform = CGAffineTransform(scaleX: 1, y: 1)
            weakSelf.prevPage = weakSelf.pageControl.currentPage
            weakSelf.pageControl.subviews[weakSelf.pageControl.currentPage].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            weakSelf.updatePositionOfDots()
        })
        .disposed(by: disposeBag)
    }
    
    /// To setup collection view cell methods
    private func setupCellConfiguration() {
      Observable.just(bannerModelArray)
        .bind(to: bannerCollectionView
          .rx
          .items(cellIdentifier: cellIdentifier,
                 cellType: DishTableHeaderCollectionViewCell.self)) {
                  row, bannerModel, cell in
                  cell.setupCellWithData(model: bannerModel)
        }
        .disposed(by: disposeBag)
    }
    
    //MARK:- Page control dots arrangement methods
    private func updatePageControlDot() {
        pageControl.subviews[prevPage].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        updatePositionOfDots()
    }
    
    /// To Update position of dot after transformation
    private func updatePositionOfDots(){
        let halfCount = CGFloat(subviews.count) / 2
        let systemDotSize: CGFloat = 7.0
        let systemDotDistance: CGFloat = 16.0
        pageControl.subviews.enumerated().forEach {
            let dot = $0.element
            dot.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.deactivate(dot.constraints)
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: systemDotSize),
                dot.heightAnchor.constraint(equalToConstant: systemDotSize),
                dot.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor, constant: 0),
                dot.centerXAnchor.constraint(equalTo: centerXAnchor, constant: systemDotDistance * (CGFloat($0.offset) - halfCount))
            ])
        }
    }
}

extension DishTableHeaderView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.size.width, height: frame.size.height)
    }
}

extension Reactive where Base: UICollectionView {
    var currentPage: Observable<Int> {
        return didEndDecelerating.map({
            let pageWidth = self.base.frame.width
            let page = floor((self.base.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            return Int(page)
        })
    }
}
