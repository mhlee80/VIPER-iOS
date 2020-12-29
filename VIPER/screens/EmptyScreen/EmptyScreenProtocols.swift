//
//  EmptyScreenProtocols.swift
//  VIPER
//
//  Created by mhlee on 2020/12/07.
//

import Foundation
import UIKit
import RxCocoa

struct EmptyScreenParams {
}

struct EmptyScreenResult {
}

enum EmptyScreenError: Error {
}

protocol EmptyScreenViewProtocol {
  var presenter: EmptyScreenPresenterProtocol { get set }
}

protocol EmptyScreenPresenterProtocol {
  var interactor: EmptyScreenInteractorProtocol { get }
  var router: EmptyScreenRouterProtocol { get }
  
  func viewDidLoad()
  func viewWillAppear()
  func viewDidAppear()
  func viewWillDisappear()
  func viewDidDisappear()
  
  var alertHandler: AlertHandler! { get set }
  var indicatorHandler: IndicatorHandler! { get set }
}

protocol EmptyScreenInteractorProtocol {
}

protocol EmptyScreenRouterProtocol {
  static func createModule(params: EmptyScreenParams, dismissHandler: ((EmptyScreenResult?, Error?) -> Void)?) -> UIViewController
  var params: EmptyScreenParams { get }
}

extension EmptyScreenPresenterProtocol {
  func viewDidLoad() {}
  func viewWillAppear() {}
  func viewDidAppear() {}
  func viewWillDisappear() {}
  func viewDidDisappear() {}
}
