//
//  BannerModel.swift
//  DinDinAssignment
//
//  Created by Aman on 24/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import Foundation
import ObjectMapper

class BannerModel: Mappable{
    
    var bannerId:String?
    var bannerImage:String?
    
    required init?(map:Map) {
        mapping(map: map)
    }
    
    func mapping(map:Map){
        bannerId <- map["id"]
        bannerImage <- map["image"]
    }
}
