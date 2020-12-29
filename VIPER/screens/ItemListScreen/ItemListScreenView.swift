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
    
    self.presenter.alertHandler = AlertHandler(vc: self)
    self.presenter.indicatorHandler = IndicatorHandler(vc: self)
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
    
    DispatchQueue.main.async { [unowned self] in
      // view-presenter binding
      self.presenter
        .isDefaultTableHidden
        .bind(to: defaultTableView.rx.isHidden)
        .disposed(by: disposeBag)
      
      self.presenter
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
      
      // post binding
      self.presenter.viewDidLoad()
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
}

/*
 다음은 view-presenter binding을 Dispatch 외부에서 할 경우 발생하는 Warning 메시지이다.
 
 [TableView] Warning once only: UITableView was told to layout its visible cells and other contents without being in the view hierarchy (the table view or one of its superviews has not been added to a window). This may cause bugs by forcing views inside the table view to load and perform layout without accurate information (e.g. table view bounds, trait collection, layout margins, safe area insets, etc), and will also cause unnecessary performance overhead due to extra layout passes. Make a symbolic breakpoint at UITableViewAlertForLayoutOutsideViewHierarchy to catch this in the debugger and see what caused this to occur, so you can avoid this action altogether if possible, or defer it until the table view has been added to a window. Table view: <UITableView: 0x7fbeb6040800; frame = (-195 -422; 390 844); clipsToBounds = YES; hidden = YES; gestureRecognizers = <NSArray: 0x600001932ca0>; layer = <CALayer: 0x600001719be0>; contentOffset: {0, 0}; contentSize: {390, 0}; adjustedContentInset: {0, 0, 0, 0}; dataSource: <RxCocoa.RxTableViewDataSourceProxy: 0x600003345440>>
  
  UITableView가 배치되기 전에, content를 로드하여 발생하는 상황으로 보인다.
  Rx로 UITableView와 data를 binding 하였는데, binding과 동시에 UITableView의 셀을 로드하는 로직이 수행되는 것으로 보인다.
  UITableView는 viewDidLoad 종료 후에, iOS 프레임워크에서 배치에 필요한 작업을 수행한다.
  viewDidLoad에서 binding을 수행하면, UITableView는 아직 화면 표시에 필요한 정보를 얻지 못한 상태이므로, 위의 메시지가 출력 되는 것으로 보인다.
  따라서 viewDidLoad 이후에 binding을 수행하면 메시지가 발생하지 않는 것으로 보인다.
  위 해결책에서는 Dispatch.main.async로 UITableView의 binding을 미루었다.
  
 */
