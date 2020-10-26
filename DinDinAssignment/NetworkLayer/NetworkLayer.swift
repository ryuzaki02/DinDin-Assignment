//
//  NetworkLayer.swift
//  DinDinAssignment
//
//  Created by Aman on 24/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import Foundation
import Moya

public enum DinDin {
    
    //To hit dishes end point
    case getDishes
}

extension DinDin: TargetType{
    public var baseURL: URL {
        return URL(string: "http://www.google.com")!
    }

    //This is the path of where dishes list comes from
    public var path: String {
        switch self {
        case .getDishes: return "/getDishes"
        }
    }

    //Assign request type here
    public var method: Moya.Method {
        switch self {
        case .getDishes: return .get
        }
    }
    
    public var sampleData: Data {
        if let path = Bundle.main.path(forResource: "DataFile", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                return data
            } catch{
            }
        }
        return Data()
    }

    public var task: Task {
        switch self {
        case .getDishes:
          return .requestParameters(
            parameters: ["Here we write params" : "In key value pair"
              ],
            encoding: URLEncoding.default)
        }
    }

    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    public var validationType: ValidationType {
        return .successCodes
    }
}
