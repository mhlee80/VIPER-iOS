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
    // warning 로그에 대한 임시 해결책
    let v = TableView()
    v.register(UITableViewCell.self, forCellReuseIdentifier: Constant.defaultCellIdentifier)
    return v
  }()
  
  lazy var customTableView: UITableView = {
    // warning 로그에 대한 임시 해결책
    let v = TableView()
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
    
    DispatchQueue.main.async { [unowned self] in
      self.presenter.viewDidLoad()
    
      // 임시 해결책이 없다면, 위의 table view binding을 아래 주석 부분으로 이동해야 한다.
//      self.presenter
//        .itemNames
//        .bind(to: defaultTableView.rx.items) { (tableView, index, itemName) -> UITableViewCell in
//          let cell = tableView.dequeueReusableCell(withIdentifier: Constant.defaultCellIdentifier)!
//          cell.textLabel?.text = itemName
//          return cell
//        }
//        .disposed(by: disposeBag)
      
//      self.presenter
//        .itemNames
//        .bind(to: customTableView.rx.items(cellIdentifier: Constant.customCellIdentifier, cellType: CustomCell.self)) { row, itemName, cell in
//          cell.textLabel?.text = itemName + "(custom cell)"
//        }
//        .disposed(by: disposeBag)
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
}

/*
 [TableView] Warning once only: UITableView was told to layout its visible cells and other contents without being in the view hierarchy (the table view or one of its superviews has not been added to a window). This may cause bugs by forcing views inside the table view to load and perform layout without accurate information (e.g. table view bounds, trait collection, layout margins, safe area insets, etc), and will also cause unnecessary performance overhead due to extra layout passes. Make a symbolic breakpoint at UITableViewAlertForLayoutOutsideViewHierarchy to catch this in the debugger and see what caused this to occur, so you can avoid this action altogether if possible, or defer it until the table view has been added to a window. Table view: <UITableView: 0x7fbeb6040800; frame = (-195 -422; 390 844); clipsToBounds = YES; hidden = YES; gestureRecognizers = <NSArray: 0x600001932ca0>; layer = <CALayer: 0x600001719be0>; contentOffset: {0, 0}; contentSize: {390, 0}; adjustedContentInset: {0, 0, 0, 0}; dataSource: <RxCocoa.RxTableViewDataSourceProxy: 0x600003345440>>
  
  위의 메시지가 표시되는데, 현재 원인 분석중. 아래는 임시 해결책
 */

fileprivate class TableView: UITableView {
  override func layoutSubviews() {
    log.info("called")
    
    guard let _ = self.window else {
      log.info("bypass layout subviews")
      return
    }
    
    log.info("do layout subviews")
    super.layoutSubviews()
  }
}
