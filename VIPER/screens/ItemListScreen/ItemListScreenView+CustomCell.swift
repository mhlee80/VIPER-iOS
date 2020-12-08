//
//  ItemListScreenView+CustomCell.swift
//  VIPER
//
//  Created by mhlee on 2020/12/08.
//

import UIKit

extension ItemListScreenView {
  class CustomCell: UITableViewCell {
    enum Constant {
    }
    
    typealias C = Constant

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}
