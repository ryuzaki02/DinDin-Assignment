//
//  DishListTableViewCell.swift
//  DinDinAssignment
//
//  Created by Aman on 23/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol DishSelectionProtocol: class {
    func dishDidSelect(dishModel: DishModel, dishIndex: Int)
}

class DishListTableViewCell: UITableViewCell {
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishDescriptionLabel: UILabel!
    @IBOutlet weak var dishTypeView: UIView!
    @IBOutlet weak var dishWeighLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var priceContainerView: UIView!
    
    private weak var delegate: DishSelectionProtocol?
    private var dishModel: DishModel!
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addShadow()
        setupPriceButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Subscribe methods
    
    /// To handle Touch Down and Touch up inside event of price button
    /// Change background color of view and price label
    private func setupPriceButton(){
        priceButton.rx.controlEvent(.touchDown)
        .subscribe(onNext: { [weak self] in
            print($0)
            self?.priceContainerView.backgroundColor = .systemGreen
            self?.priceLabel.text = "added +1"
        }).disposed(by: disposeBag)
        
        priceButton.rx.controlEvent(.touchUpInside)
        .subscribe(onNext: { [weak self] in
            guard let weakSelf = self else {return}
            print($0)
            weakSelf.priceContainerView.backgroundColor = .black
            weakSelf.priceLabel.text = weakSelf.dishModel.dishPrice ?? "0" + " USD"
            weakSelf.priceLabel.textColor = .white
            weakSelf.delegate?.dishDidSelect(dishModel: weakSelf.dishModel, dishIndex: weakSelf.tag)
        }).disposed(by: disposeBag)
    }

    //MARK:- Setup cell with data
    func setupCellWithData(model: DishModel, delegate: DishSelectionProtocol?) {
        dishModel = model
        self.delegate = delegate
        switch model.dishType {
        case .NA:
            dishTypeView.isHidden = true
        case .Veg:
            dishTypeView.backgroundColor = .green
            dishTypeView.isHidden = false
        case .NonVeg:
            dishTypeView.backgroundColor = .red
            dishTypeView.isHidden = false
        }
        dishNameLabel.text = model.dishName ?? "Not Available"
        dishDescriptionLabel.text = model.dishDescription ?? "Not Available"
        dishWeighLabel.text = model.dishSize ?? "Not Available"
        priceLabel.text = model.dishPrice ?? "0" + " USD"
        dishImageView.image = UIImage.init(named: model.dishImage ?? "noPreview")
    }
    
}
