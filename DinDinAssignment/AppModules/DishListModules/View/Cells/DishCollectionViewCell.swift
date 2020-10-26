//
//  DishCollectionViewCell.swift
//  DinDinAssignment
//
//  Created by Aman on 25/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DishCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: MyTableView!
    
    private let disposeBag = DisposeBag()
    private let cellIdentifier = "DishListTableViewCell"
    weak var dishSelectionDelegate: DishSelectionProtocol?
    private var dishModelArray: BehaviorRelay<[DishModel]> = BehaviorRelay(value: [])

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        /// To create table view cells with items
        dishModelArray.asObservable()
            .bind(to:
            tableView.rx.items(cellIdentifier: cellIdentifier,
                               cellType: DishListTableViewCell.self)) {[weak self] row, dishModel, cell in
                                guard let weakSelf = self else{return}
                                cell.setupCellWithData(model: dishModel, delegate: weakSelf.dishSelectionDelegate)
            }
        .disposed(by: disposeBag)
        
    }
    
    //MARK:- Setup cell
    func updateCellData(dishModelArray: [DishModel]) {
        self.dishModelArray.accept(dishModelArray)
    }
}

final class MyTableView: UITableView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    var lastContentOffset: CGPoint = .zero

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = contentOffset
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lastContentOffset = contentOffset
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        lastContentOffset = contentOffset
    }
}
