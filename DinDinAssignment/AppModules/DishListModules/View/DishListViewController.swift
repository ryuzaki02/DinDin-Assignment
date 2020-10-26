//
//  DishListViewController.swift
//  DinDinAssignment
//
//  Created by Aman on 23/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DishListViewController: UIViewController {
    
    enum CollectionViewTag: Int {
        case DishList = 1000
        case Category = 1001
    }
    
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var cartButton: UIView!
    @IBOutlet weak var cartContainerView: UIView!
    @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var cartCountView: UIView!
    @IBOutlet private weak var containterScrollView: MyScrollView!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!

    private var dishTableHeaderView: DishTableHeaderView!
    var presentor:ViewToPresenterProtocol?
    private let estimatedRowHeight: CGFloat = 545
    private let overlappedPadding: CGFloat = 100
    private let categoryCollectionViewWidth: CGFloat = 100
    private var categoryModelArray: [CategoryModel] = []
    private var selectedDishModelArray: BehaviorRelay<[DishModel]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()
    private let dishListCollectionCellIdentifier = "DishCollectionViewCell"
    private let categoryCollectionCellIdentifier = "DishCategoryCollectionViewCell"
    private var previousCategoryIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHeaderView()
        setupCollectionView()
        setupCartObserver()
        setupTopViewObserver()
        subscribeMainCollectionViewScrollObserver()
        setupCategoryCellTapObserver()
        roundedView.roundCorners(corners: [.topLeft, .topRight], radius: 40.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentor?.startFetchingDishes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if categoryModelArray.count > 0,
            let cell = categoryCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? DishCategoryCollectionViewCell{
            cell.categoryLabel.textColor = .black
        }
    }
    
    //MARK:- Setup UI
    
    /// Provide shadow to cart view
    private func setupUI(){
        cartContainerView.addShadow()
    }
    
    //MARK:- Setup views
    
    /// Setup all collection views
    private func setupCollectionView(){
        mainCollectionView.tag = CollectionViewTag.DishList.rawValue
        categoryCollectionView.tag = CollectionViewTag.Category.rawValue
        mainCollectionView.delegate = self
        mainCollectionView.register(UINib(nibName: dishListCollectionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: dishListCollectionCellIdentifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.register(UINib(nibName: categoryCollectionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: categoryCollectionCellIdentifier)
        containterScrollView.contentInset = .init(top: topView.frame.size.height - overlappedPadding, left: 0, bottom: 0, right: 0)
    }
    
    /// Setup custom header view and then added to top view
    private func setupHeaderView(){
        dishTableHeaderView = DishTableHeaderView.instanceFromNib()
        dishTableHeaderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: topView.frame.size.height)
        topView.addSubview(dishTableHeaderView)
        topView.bringSubviewToFront(dishTableHeaderView)
    }
    
    //MARK:- Set up observers
    
    /// To Handle items added to card and then updates its count
    private func setupCartObserver() {
        selectedDishModelArray.asObservable()
        .subscribe(onNext: {
          [weak self] dishes in
            self?.cartCountView.isHidden = dishes.count > 0 ? false : true
            self?.cartCountLabel.text = "\(dishes.count)"
            if dishes.count > 1{
                self?.animateCarCountLabel()
            }
        })
        .disposed(by: disposeBag)
    }
    
    /// To Handle main dish list collection view data
    private func setupDishListCollectionCellObserver() {
      Observable.just(categoryModelArray)
        .bind(to: mainCollectionView
          .rx
          .items(cellIdentifier: dishListCollectionCellIdentifier,
                 cellType: DishCollectionViewCell.self)) {
                    [weak self] row, categoryModel, cell in
                    self?.setupDishListTableViewCellObserver(cell: cell)
                    cell.updateCellData(dishModelArray: categoryModel.dishModelArray)
                    cell.dishSelectionDelegate = self
        }
        .disposed(by: disposeBag)
    }
    
    /// To Handle scroll of scroll view to scroll of main dist list table view
    private func setupDishListTableViewCellObserver(cell: DishCollectionViewCell){
        containterScrollView.rx.didScroll
            .filter { [unowned self] _ in self.containterScrollView.contentOffset.y <= CGFloat(0.0) }
            .filter { _ in cell.tableView.isTracking }
            .map { _ in cell.tableView.lastContentOffset }
            .bind(to: cell.tableView.rx.contentOffset)
            .disposed(by: disposeBag)
    }
    
    /// To Handle category collection view data
    private func setupCategoriesCollectionCellObserver() {
         Observable.just(categoryModelArray)
           .bind(to: categoryCollectionView
             .rx
             .items(cellIdentifier: categoryCollectionCellIdentifier,
                    cellType: DishCategoryCollectionViewCell.self)) {
                       row, categoryModel, cell in
                        cell.updateCellData(categoryModel: categoryModel)
            }
           .disposed(by: disposeBag)
    }
    
    /// To Change Top view (header) content offset on change of scoll view scrolling
    private func setupTopViewObserver(){
        containterScrollView.rx.contentOffset
            .subscribe(onNext: { [weak self] in
            guard let weakSelf = self else {return}
                var headerRect = weakSelf.topView.frame
                if $0.y < 0{
                    headerRect.origin.y = -$0.y - weakSelf.topView.frame.size.height + weakSelf.overlappedPadding
                }
                weakSelf.topView.frame = headerRect
            })
            .disposed(by: disposeBag)
    }
    
    /// To handle scroll of main collection view which updates category collection view data
    private func subscribeMainCollectionViewScrollObserver() {
        mainCollectionView.rx.currentPage
        .subscribe(onNext: { [weak self] in
            guard let weakSelf = self
                else{return}
            weakSelf.categoryCollectionView.scrollToItem(at: IndexPath(row: $0, section: 0), at: .centeredVertically, animated: true)
            weakSelf.updateCategoryCollectionViewCellTextColor(currentIndex: $0)
        })
        .disposed(by: disposeBag)
    }
    
    /// To handle category collection view didSelectItem(at:) method
    private func setupCategoryCellTapObserver() {
      categoryCollectionView
        .rx
        .itemSelected
        .subscribe(onNext: { [weak self] indexPath in
            guard let weakSelf = self
            else{return}
            weakSelf.mainCollectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            weakSelf.updateCategoryCollectionViewCellTextColor(currentIndex: indexPath.row)
        })
        .disposed(by: disposeBag)
    }
    
    //MARK:- Animate cart count label
    /// Animate zoom in out of cart count label
    private func animateCarCountLabel() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.cartCountView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }) {[weak self] (bool) in
            self?.cartCountView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    //MARK:- Update Text color of category
    /// To Handle scrolling of either Main collection view or Category collection view
    /// Updates color of label in Category collection view
    private func updateCategoryCollectionViewCellTextColor(currentIndex: Int){
        if let cell = categoryCollectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as? DishCategoryCollectionViewCell{
            cell.categoryLabel.textColor = .black
        }
        if let cell = categoryCollectionView.cellForItem(at: IndexPath(row: previousCategoryIndex, section: 0)) as? DishCategoryCollectionViewCell{
            cell.categoryLabel.textColor = .lightGray
        }
        previousCategoryIndex = currentIndex
    }
}

/// To Handle data from either server or local
extension DishListViewController:PresenterToViewProtocol{    
    func showDishList(dishListModel: DishListModel) {
        view.hideProgressIndicator()
        categoryModelArray = dishListModel.categoryModelArray.sorted { $0.categoryName < $1.categoryName }

        setupDishListCollectionCellObserver()
        setupCategoriesCollectionCellObserver()
        
        if let bannerArray = dishListModel.bannerArray{
            dishTableHeaderView.updateCollectionViewData(bannerModelArary: bannerArray)
        }
    }
    
    //If get data from server
    func showError(error: Error) {
        view.hideProgressIndicator()
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription.isEmpty ? "Failed to fetch dishes." : error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension DishListViewController: DishSelectionProtocol{
    /// Handle did select protocol for item selection from different dist list table
    func dishDidSelect(dishModel: DishModel, dishIndex: Int) {
        let array = selectedDishModelArray.value + [dishModel]
        selectedDishModelArray.accept(array)
    }
}

extension DishListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == CollectionViewTag.Category.rawValue{
            return CGSize(width: categoryCollectionViewWidth, height: collectionView.frame.size.height)
        }else{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
}

final class MyScrollView: UIScrollView, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInits()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInits()
    }

    private func customInits() {
        bounces = false
        scrollsToTop = false
        showsVerticalScrollIndicator = false
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.first?.hitTest(point, with: nil) != nil
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
