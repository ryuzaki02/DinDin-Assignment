//
//  DishListRouter.swift
//  DinDinAssignment
//
//  Created by Aman on 23/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import Foundation
import UIKit

class DishListRouter: PresenterToRouterProtocol{
    static func createController() -> DishListViewController {
        let view = mainstoryboard.instantiateViewController(withIdentifier: "DishListViewController") as! DishListViewController
        
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = DishListPresenter()
        let interactor: PresenterToInteractorProtocol = DishListInteractor()
        let router:PresenterToRouterProtocol = DishListRouter()
        
        view.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
        
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
