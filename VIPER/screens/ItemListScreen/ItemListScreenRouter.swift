//
//  ItemListScreenRouter.swift
//  VIPER
//
//  Created by mhlee on 2020/12/08.
//

import UIKit
import Foundation

class ItemListScreenRouter: ItemListScreenRouterProtocol {
  static func createModule(params: ItemListScreenParams, dismissHandler: ((ItemListScreenResult?, Error?) -> Void)?) -> UIViewController {
    let interactor = ItemListScreenInteractor()
    let router = ItemListScreenRouter(params: params)
    let presenter = ItemListScreenPresenter(interactor: interactor, router: router)
    let view = ItemListScreenView(presenter: presenter)

    router.vc = view
    router.dismissHandler = dismissHandler
    
    return view
  }
  
  var params: ItemListScreenParams
  weak var vc: UIViewController!
  var dismissHandler: ((ItemListScreenResult?, Error?) -> Void)?
  
  init(params: ItemListScreenParams) {
    self.params = params
  }
  
  func dismiss(result: ItemListScreenResult?, error: ItemListScreenError?) {
    vc.dismiss(animated: true) { [unowned self] in
      self.dismissHandler?(result, error)
    }
  }
}
