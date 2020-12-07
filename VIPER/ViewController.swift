//
//  ViewController.swift
//  VIPER
//
//  Created by mhlee on 2020/12/04.
//

import UIKit

class ViewController: UIViewController {
  enum Example: Int, CaseIterable {
    case emptyScreen
    
    var description: String {
      switch self {
        case .emptyScreen:
          return "빈 화면"
      }
    }
  }
  
  lazy var tableView: UITableView = {
    let v = UITableView()
    return v
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    title = "VIPER 예제"
    
    view.backgroundColor = .white
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.top.left.bottom.right.equalToSuperview()
    }
    
    tableView.dataSource = self
    tableView.delegate = self
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    Example.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = Example(rawValue: indexPath.row)!.description
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch Example(rawValue: indexPath.row)! {
      case .emptyScreen:
        let screen = EmptyScreenRouter.createModule(params: EmptyScreenParams(), dismissHandler: nil)
        navigationController?.pushViewController(screen, animated: true)
    }
  }
}
