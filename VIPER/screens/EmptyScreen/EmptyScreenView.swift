//
//  EmptyScreenView.swift
//  VIPER
//
//  Created by mhlee on 2020/12/07.
//

import UIKit
import Foundation
import RxSwift
import SnapKit

class EmptyScreenView: UIViewController, EmptyScreenViewProtocol {
  enum Constant {
  }
  
  typealias C = Constant
  
  var presenter: EmptyScreenPresenterProtocol
  
  let disposeBag = DisposeBag()
  
  lazy var label: UILabel = {
    let v = UILabel()
    v.text = "EmptyScreen"
    return v
  }()
 
  init(presenter: EmptyScreenPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
    
    self.presenter.alertHandler = AlertHandler(vc: self)
    self.presenter.indicatorHandler = IndicatorHandler(vc: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    view.backgroundColor = .white
      
    view.addSubview(label)
            
    label.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
    }
    
    DispatchQueue.main.async { [unowned self] in
      self.presenter.viewDidLoad()
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
}
