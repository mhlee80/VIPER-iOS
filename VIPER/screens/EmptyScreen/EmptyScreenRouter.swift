//
//  EmptyScreenWireframe.swift
//  VIPER
//
//  Created by mhlee on 2020/12/07.
//

import UIKit
import Foundation

class EmptyScreenRouter: EmptyScreenRouterProtocol {
  static func createModule(params: EmptyScreenParams, dismissHandler: ((EmptyScreenResult?, Error?) -> Void)?) -> UIViewController {
    let interactor = EmptyScreenInteractor()
    let router = EmptyScreenRouter(params: params)
    let presenter = EmptyScreenPresenter(interactor: interactor, router: router)
    let view = EmptyScreenView(presenter: presenter)

    router.vc = view
    router.dismissHandler = dismissHandler
    
    return view
  }
  
  var params: EmptyScreenParams
  weak var vc: UIViewController!
  var dismissHandler: ((EmptyScreenResult?, Error?) -> Void)?
  
  init(params: EmptyScreenParams) {
    self.params = params
  }
  
  func dismiss(result: EmptyScreenResult?, error: EmptyScreenError?) {
    vc.dismiss(animated: true) { [unowned self] in
      self.dismissHandler?(result, error)
    }
  }
}
