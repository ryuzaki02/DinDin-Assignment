//
//  DishTableHeaderCollectionViewCell.swift
//  DinDinAssignment
//
//  Created by Aman on 23/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import UIKit

class DishTableHeaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- Setup cell with data
    func setupCellWithData(model: BannerModel) {
        bannerImageView.image = UIImage.init(named: model.bannerImage ?? "noPreview")
    }

}
