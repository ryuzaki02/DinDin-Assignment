//
//  DishCategoryCollectionViewCell.swift
//  DinDinAssignment
//
//  Created by Aman on 25/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import UIKit

class DishCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        categoryLabel.textColor = .lightGray
        // Initialization code
    }
    
    //MARK:- Setup cell
    func updateCellData(categoryModel: CategoryModel) {
        categoryLabel.text = categoryModel.categoryName
    }
}
