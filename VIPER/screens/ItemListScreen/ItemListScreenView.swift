//
//  ItemListScreenView.swift
//  VIPER
//
//  Created by mhlee on 2020/12/08.
//

import UIKit
import Foundation
import RxSwift
import SnapKit

class ItemListScreenView: UIViewController, ItemListScreenViewProtocol {
  enum Constant {
    static let defaultCellIdentifier = "defaultCell"
    static let customCellIdentifier = "customCell"
  }
  
  typealias C = Constant
  
  var presenter: ItemListScreenPresenterProtocol
  
  let disposeBag = DisposeBag()
  
  lazy var defaultTableView: UITableView = {
    let v = UITableView()
    v.register(UITableViewCell.self, forCellReuseIdentifier: Constant.defaultCellIdentifier)
    return v
  }()
  
  lazy var customTableView: UITableView = {
    let v = UITableView()
    v.register(CustomCell.self, forCellReuseIdentifier: Constant.customCellIdentifier)
    return v
  }()
 
  init(presenter: ItemListScreenPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    title = "ItemList"
    
    view.backgroundColor = .white
    
    view.addSubview(defaultTableView)
    view.addSubview(customTableView)
            
    defaultTableView.snp.makeConstraints { make in
      make.top.left.bottom.right.equalTo(view.safeAreaLayoutGuide)
    }
    
    customTableView.snp.makeConstraints { make in
      make.top.left.bottom.right.equalTo(view.safeAreaLayoutGuide)
    }
    
    presenter
      .isDefaultTableHidden
      .bind(to: defaultTableView.rx.isHidden)
      .disposed(by: disposeBag)
    
    presenter
      .isCustomTableHidden
      .bind(to: customTableView.rx.isHidden)
      .disposed(by: disposeBag)
    
    DispatchQueue.main.async { [unowned self] in
      self.presenter.viewDidLoad()
      
      self.presenter
        .itemNames
        .bind(to: defaultTableView.rx.items) { (tableView, index, itemName) -> UITableViewCell in
          let cell = tableView.dequeueReusableCell(withIdentifier: Constant.defaultCellIdentifier)!
          cell.textLabel?.text = itemName
          return cell
        }
        .disposed(by: disposeBag)
      
      self.presenter
        .itemNames
        .bind(to: customTableView.rx.items(cellIdentifier: Constant.customCellIdentifier, cellType: CustomCell.self)) { row, itemName, cell in
          cell.textLabel?.text = itemName + "(custom cell)"
        }
        .disposed(by: disposeBag)
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
}
