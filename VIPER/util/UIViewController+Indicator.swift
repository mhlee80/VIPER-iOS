//
//  UIViewController+Indicator.swift
//  PURPLE
//
//  Created by mhlee on 2020/12/17.
//

import UIKit

class IndicatorHandler {
  private weak var vc: UIViewController?
  init(vc: UIViewController) {
    self.vc = vc
  }
  
  func show(message: String? = nil, completion: (() -> Void)? = nil) {
    if let _ = vc?.presentedViewController as? IndicatorViewController {
      return
    }
    
    let indicatorViewController = IndicatorViewController()
    vc?.present(indicatorViewController, animated: true, completion: completion)
  }
  
  func hide(completion: (() -> Void)? = nil) {
    guard let indicatorViewController = vc?.presentedViewController as? IndicatorViewController else {
      return
    }
    
    indicatorViewController.dismiss(animated: true, completion: completion)
  }
}

extension UIViewController {
  func showIndicator(message: String? = nil, completion: (() -> Void)? = nil) {
    let handler = IndicatorHandler(vc: self)
    handler.show(message: message, completion: completion)
  }
  
  func hideIndicator(completion: (() -> Void)? = nil) {
    let handler = IndicatorHandler(vc: self)
    handler.hide(completion: completion)
  }
}

fileprivate class IndicatorViewController: UIViewController {
  enum Constant {
    static let backgroundColor: UIColor = .init(white: 0.0, alpha: 0.5)
    static let containerBackgroundColor: UIColor = .white
    static let containerLeftOffset: CGFloat = 25
    static let containerRightOffset: CGFloat = -25
    static let containerCornerRadius: CGFloat = 20
//    static let stackTopOffset: CGFloat = 30
//    static let stackLeftOffset: CGFloat = 30
//    static let stackBottomOffset: CGFloat = -30
//    static let stackRightOffset: CGFloat = -30
    static let stackLayoutMargins: UIEdgeInsets = .init(top: 30, left: 30, bottom: 30, right: 30)
    static let stackSpacing: CGFloat = 20
    static let spinnerSize: CGSize = .init(width: 43, height: 43)
    static let spinnerColor: UIColor = .black
    static let messageFont: UIFont = .systemFont(ofSize: 14, weight: .medium)
    static let messageColor: UIColor = .black
  }
  
  typealias C = Constant
  
  lazy var indicatorView: UIView = {
    let v = UIView()
    v.backgroundColor = C.containerBackgroundColor
    v.layer.cornerRadius = C.containerCornerRadius
    v.clipsToBounds = true
    return v
  }()
  
  lazy var stackView: UIStackView = {
    let v = UIStackView()
    v.axis = .vertical
    v.alignment = .center
    v.spacing = C.stackSpacing
    v.addArrangedSubview(spinner)
    v.addArrangedSubview(messageLabel)
    return v
  }()
  
  lazy var spinner: CircleStrokeSpinner = {
    let v = CircleStrokeSpinner(frame: .init(origin: .zero, size: C.spinnerSize), color: C.spinnerColor, lineWidth: 5)
    return v
  }()
  
  lazy var messageLabel: UILabel = {
    let v = UILabel()
    v.isHidden = true
    v.numberOfLines = 0
    v.textAlignment = .center
    v.font = C.messageFont
    v.textColor = C.messageColor
    return v
  }()
  
  init(message: String? = nil) {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
    
    messageLabel.text = message
    messageLabel.isHidden = message == nil
  }
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = C.backgroundColor

    view.addSubview(indicatorView)
    indicatorView.addSubview(stackView)

    indicatorView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().offset(C.containerLeftOffset)
      make.right.equalToSuperview().offset(C.containerRightOffset)
    }

    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = C.stackLayoutMargins
    stackView.snp.makeConstraints { make in
      make.top.left.bottom.right.equalToSuperview()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    spinner.startAnimating()
  }
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    spinner.stopAnimating()
    super.dismiss(animated: flag, completion: completion)
  }
}
