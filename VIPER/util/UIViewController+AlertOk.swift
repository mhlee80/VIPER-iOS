//
//  UIViewController+AlertOk.swift
//  PURPLE
//
//  Created by mhlee on 2020/12/14.
//

import UIKit
import Foundation

class AlertHandler {
  private weak var vc: UIViewController?
  init(vc: UIViewController) {
    self.vc = vc
  }
  
  func showOk(message: String?, completion: (() -> Void)? = nil) {
    let alert = AlertOkViewController(message: message, completion: completion)
    vc?.present(alert, animated: true)
  }
}

extension UIViewController {
  func showAlertOk(message: String?, completion: (() -> Void)? = nil) {
    let alertHandler = AlertHandler(vc: self)
    alertHandler.showOk(message: message, completion: completion)
  }
}

fileprivate class AlertOkViewController: UIViewController {
  enum Constant {
    static let backgroundColor: UIColor = .init(white: 0.0, alpha: 0.5)
    static let alertBackgroundColor: UIColor = .white
    static let alertLeftOffset: CGFloat = 25
    static let alertRightOffset: CGFloat = -25
    static let alertCornerRadius: CGFloat = 20
    static let stackTopOffset: CGFloat = 30
    static let stackLeftOffset: CGFloat = 30
    static let stackRightOffset: CGFloat = -30
    static let stackSpacing: CGFloat = 10
    static let messageFont: UIFont = .systemFont(ofSize: 14, weight: .medium)
    static let messageColor: UIColor = .black
    static let separatorTopOffset: CGFloat = 30
    static let separatorSize: CGSize = .init(width: UIView.noIntrinsicMetric, height: 1)
    static let separatorColor: UIColor = .init(white: 0.8, alpha: 1.0)
    static let okSize: CGSize = .init(width: UIView.noIntrinsicMetric, height: 45)
    static let okTitleFont: UIFont = .systemFont(ofSize: 14, weight: .medium)
    static let okTitleColor: UIColor = .black
    static let okTitleDefaultText = "확인"
  }
  
  typealias C = Constant
      
  lazy var alertView: UIView = {
    let v = UIView()
    v.backgroundColor = C.alertBackgroundColor
    v.layer.cornerRadius = C.alertCornerRadius
    v.clipsToBounds = true
    return v
  }()
  
  lazy var stackView: UIStackView = {
    let v = UIStackView()
    v.axis = .vertical
    v.spacing = C.stackSpacing
    v.addArrangedSubview(iconImageView)
    v.addArrangedSubview(messageLabel)
    return v
  }()
  
  lazy var iconImageView: UIImageView = {
    let v = UIImageView()
    return v
  }()
  
  lazy var messageLabel: UILabel = {
    let v = UILabel()
    v.numberOfLines = 0
    v.textAlignment = .center
    v.font = C.messageFont
    v.textColor = C.messageColor
    return v
  }()
  
  lazy var separator: UIView = {
    let v = Separator()
    v.size = C.separatorSize
    v.backgroundColor = C.separatorColor
    return v
  }()
  
  lazy var okButton: UIButton = {
    let v = Button()
    v.size = C.okSize
    v.titleLabel?.font = C.okTitleFont
    v.setTitleColor(C.okTitleColor, for: .normal)
    return v
  }()
  
  var completion: (() -> Void)?
  
  init(image: UIImage? = nil, message: String? = nil, okTitleText: String? = nil, completion: (() -> Void)? = nil) {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
    
    iconImageView.isHidden = image == nil
    messageLabel.isHidden = message == nil
    
    iconImageView.image = image
    messageLabel.text = message
    okButton.setTitle(okTitleText ?? C.okTitleDefaultText, for: .normal)
    
    self.completion = completion
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    view.backgroundColor = C.backgroundColor
    
    view.addSubview(alertView)
    alertView.addSubview(stackView)
    alertView.addSubview(separator)
    alertView.addSubview(okButton)
    
    alertView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().offset(C.alertLeftOffset)
      make.right.equalToSuperview().offset(C.alertRightOffset)
    }
    
    stackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(C.stackTopOffset)
      make.left.equalToSuperview().offset(C.stackLeftOffset)
      make.right.equalToSuperview().offset(C.stackRightOffset)
    }
    
    separator.snp.makeConstraints { make in
      make.top.equalTo(stackView.snp.bottom).offset(C.separatorTopOffset)
      make.left.right.equalToSuperview()
    }
    
    okButton.snp.makeConstraints { make in
      make.top.equalTo(separator.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
    
    okButton.addTarget(self, action: #selector(handleOkPressed(_:)), for: .touchUpInside)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  @objc private func handleOkPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: completion)
  }
}

fileprivate class Separator: UIView {
  var size: CGSize = .zero {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    return size
  }
}

fileprivate class Button: UIButton {
  var size: CGSize = .zero {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    return size
  }
}
