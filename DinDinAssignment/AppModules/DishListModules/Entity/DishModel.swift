//
//  DishModel.swift
//  DinDinAssignment
//
//  Created by Aman on 23/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import Foundation
import ObjectMapper

class DishModel: Mappable{
    
    enum DishType {
        case Veg
        case NonVeg
        case NA
        
        init(type: String) {
            if type == "Veg"{
                self = .Veg
            }else if type == "Non-Veg"{
                self = .NonVeg
            }else{
                self = .NA
            }
        }
    }
    
    var dishId:String?
    var dishName:String?
    var dishDescription:String?
    var dishSize:String?
    var dishPrice:String?
    var dishImage:String?
    private var dishTypeString:String?
    lazy var dishType: DishType = DishType.init(type: dishTypeString ?? "")
    
    required init?(map:Map) {
        mapping(map: map)
    }
    
    func mapping(map:Map){
        dishId <- map["dishId"]
        dishName <- map["dishName"]
        dishDescription <- map["dishDescription"]
        dishSize <- map["dishSize"]
        dishPrice <- map["dishPrice"]
        dishImage <- map["dishImage"]
        dishTypeString <- map["dishType"]
    }
}
