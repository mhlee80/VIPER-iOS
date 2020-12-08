//
//  ItemListScreenProtocols.swift
//  VIPER
//
//  Created by mhlee on 2020/12/08.
//

import Foundation
import UIKit
import RxCocoa

struct ItemListScreenParams {
  enum Kind {
    case defaultCell
    case customCell
  }
  
  let kind: Kind
}

struct ItemListScreenResult {
}

enum ItemListScreenError: Error {
}

protocol ItemListScreenViewProtocol {
  var presenter: ItemListScreenPresenterProtocol { get set }
}

protocol ItemListScreenPresenterProtocol {
  var interactor: ItemListScreenInteractorProtocol { get }
  var router: ItemListScreenRouterProtocol { get }
  
  func viewDidLoad()
  func viewWillAppear()
  func viewDidAppear()
  func viewWillDisappear()
  func viewDidDisappear()
  
  var isDefaultTableHidden: BehaviorRelay<Bool> { get }
  var isCustomTableHidden: BehaviorRelay<Bool> { get }
  var itemNames: BehaviorRelay<[String]> { get }
}

protocol ItemListScreenInteractorProtocol {
  var itemNames: [String] { get }
}

protocol ItemListScreenRouterProtocol {
  static func createModule(params: ItemListScreenParams, dismissHandler: ((ItemListScreenResult?, Error?) -> Void)?) -> UIViewController
  var params: ItemListScreenParams { get }
}

extension ItemListScreenPresenterProtocol {
  func viewDidLoad() {}
  func viewWillAppear() {}
  func viewDidAppear() {}
  func viewWillDisappear() {}
  func viewDidDisappear() {}
}
