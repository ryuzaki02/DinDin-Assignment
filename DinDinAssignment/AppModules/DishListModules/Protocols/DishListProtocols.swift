//
//  DishListProtocols.swift
//  DinDinAssignment
//
//  Created by Aman on 23/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import Foundation
import UIKit

protocol ViewToPresenterProtocol: class{
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    func startFetchingDishes()
}

protocol PresenterToViewProtocol: class{
    func showDishList(dishListModel:DishListModel)
    func showError(error: Error)
}

protocol PresenterToRouterProtocol: class{
    static func createController()-> DishListViewController
}

protocol PresenterToInteractorProtocol: class{
    var presenter:InteractorToPresenterProtocol? {get set}
    func fetchLocalDishList()
    func fetchDishListFromServer()
}

protocol InteractorToPresenterProtocol: class{
    func dataFetchedSuccess(dishListModel:DishListModel)
    func dataFetchFailed(error: Error)
}
