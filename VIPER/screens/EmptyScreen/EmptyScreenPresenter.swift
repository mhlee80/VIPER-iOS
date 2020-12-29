//
//  EmptyScreenPresenter.swift
//  VIPER
//
//  Created by mhlee on 2020/12/07.
//

import Foundation
import RxCocoa

class EmptyScreenPresenter: EmptyScreenPresenterProtocol {  
  var interactor: EmptyScreenInteractorProtocol
  var router: EmptyScreenRouterProtocol
  
  var alertHandler: AlertHandler!
  var indicatorHandler: IndicatorHandler!
  
  init(interactor: EmptyScreenInteractorProtocol, router: EmptyScreenRouterProtocol) {
    self.interactor = interactor
    self.router = router
  }

  func viewDidLoad() {
  }
}
