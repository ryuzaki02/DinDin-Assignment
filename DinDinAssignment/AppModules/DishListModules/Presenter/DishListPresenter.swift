//
//  DishListPresenter.swift
//  DinDinAssignment
//
//  Created by Aman on 23/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import Foundation
import UIKit

class DishListPresenter:ViewToPresenterProtocol {
    var view: PresenterToViewProtocol?
    
    var interactor: PresenterToInteractorProtocol?
    
    var router: PresenterToRouterProtocol?
    
    func startFetchingDishes() {
        interactor?.fetchLocalDishList()
    }
}

extension DishListPresenter: InteractorToPresenterProtocol{
    func dataFetchedSuccess(dishListModel: DishListModel) {
        view?.showDishList(dishListModel: dishListModel)
    }
    
    func dataFetchFailed(error: Error) {
        view?.showError(error: error)
    }
    
}
