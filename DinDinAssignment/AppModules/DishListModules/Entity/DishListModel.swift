//
//  DishListModel.swift
//  DinDinAssignment
//
//  Created by Aman on 24/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import Foundation
import ObjectMapper

struct CategoryModel {
    var categoryName: String
    var dishModelArray: [DishModel]
}

class DishListModel: Mappable{
    private var categoriesDict: [String: [DishModel]]?
    var bannerArray: [BannerModel]?
    var categoryModelArray: [CategoryModel] {
        guard let dict = categoriesDict else {return []}
        var categories: [CategoryModel] = []
        for (key,value) in dict{
            categories.append(CategoryModel(categoryName: key, dishModelArray: value))
        }
        return categories
    }
    
    required init?(map:Map) {
        mapping(map: map)
    }
    
    func mapping(map:Map){
        categoriesDict <- map["categories"]
        bannerArray <- map["banners"]
    }
    
}
