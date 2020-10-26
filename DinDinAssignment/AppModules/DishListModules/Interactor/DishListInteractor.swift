//
//  DishListInteractor.swift
//  DinDinAssignment
//
//  Created by Aman on 23/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

class DishListInteractor: PresenterToInteractorProtocol{
    var presenter: InteractorToPresenterProtocol?
    
    lazy var provider = MoyaProvider<DinDin>()
    
    func fetchDishListFromServer() {
        provider.request(.getDishes) { [weak self] result in
          guard let self = self else { return }
          switch result {
          case .success(let response):
            do {
                if let json = try JSONSerialization.jsonObject(with: response.data) as? [String : Any]{
                    //Process response from server
                    print(json)
                }
            } catch (let error){
                self.presenter?.dataFetchFailed(error: error)
            }
          case .failure(let error):
            self.presenter?.dataFetchFailed(error: error)
          }
        }
    }
    
    func fetchLocalDishList() {
        var json: Any?
        if let path = Bundle.main.path(forResource: LocalJsonFile, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data)
            } catch (let error){
                presenter?.dataFetchFailed(error: error)
            }
        }
        if let dict = json as? [String: Any],
            let dishListModel = Mapper<DishListModel>().map(JSON: dict){
            presenter?.dataFetchedSuccess(dishListModel: dishListModel)
        }else{
            presenter?.dataFetchFailed(error: NSError(domain: ParsinngFailed, code: 0, userInfo: nil))
        }
    }
}
