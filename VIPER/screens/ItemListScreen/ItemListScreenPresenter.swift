//
//  ItemListScreenPresenter.swift
//  VIPER
//
//  Created by mhlee on 2020/12/08.
//

import Foundation
import RxCocoa

class ItemListScreenPresenter: ItemListScreenPresenterProtocol {
  var interactor: ItemListScreenInteractorProtocol
  var router: ItemListScreenRouterProtocol
  
  var isDefaultTableHidden: BehaviorRelay<Bool> = .init(value: true)
  var isCustomTableHidden: BehaviorRelay<Bool> = .init(value: true)
  
  var itemNames: BehaviorRelay<[String]> = .init(value: [])
  
  init(interactor: ItemListScreenInteractorProtocol, router: ItemListScreenRouterProtocol) {
    self.interactor = interactor
    self.router = router
  }

  func viewDidLoad() {
    switch router.params.kind {
      case .defaultCell:
        isDefaultTableHidden.accept(false)
      case .customCell:
        isCustomTableHidden.accept(false)
    }
    itemNames.accept(interactor.itemNames)
  }
}
