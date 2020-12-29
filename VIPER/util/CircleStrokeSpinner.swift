//
//  CircleStrokeSpinner.swift
//  PURPLE
//
//  Created by mhlee on 2020/12/18.
//

import UIKit

/// Activity indicator view with nice animations
public final class CircleStrokeSpinner: UIView {
  
  /// Default color of activity indicator. Default value is UIColor.white.
  public static var DEFAULT_COLOR = UIColor.white
  
  /// Default color of text. Default value is UIColor.white.
  public static var DEFAULT_TEXT_COLOR = UIColor.white
  
  /// Default padding. Default value is 0.
  public static var DEFAULT_PADDING: CGFloat = 0
  
  /// Default line width. Default value is 2.
  public static var DEFAULT_LINE_WIDTH: CGFloat = 2
  
  /// Default line cap. Default value is round.
  public static var DEFAULT_LINE_CAP: CAShapeLayerLineCap = .round
  
  /// Default size of activity indicator view in UI blocker. Default value is 60x60.
  public static var DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
  
  /// Default display time threshold to actually display UI blocker. Default value is 0 ms.
  ///
  /// - note:
  /// Default time that has to be elapsed (between calls of `startAnimating()` and `stopAnimating()`) in order to actually display UI blocker. It should be set thinking about what the minimum duration of an activity is to be worth showing it to the user. If the activity ends before this time threshold, then it will not be displayed at all.
  public static var DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 0
  
  /// Default minimum display time of UI blocker. Default value is 0 ms.
  ///
  /// - note:
  /// Default minimum display time of UI blocker. Its main purpose is to avoid flashes showing and hiding it so fast. For instance, setting it to 200ms will force UI blocker to be shown for at least this time (regardless of calling `stopAnimating()` ealier).
  public static var DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 0
  
  /// Default message displayed in UI blocker. Default value is nil.
  public static var DEFAULT_BLOCKER_MESSAGE: String?
  
  /// Default message spacing to activity indicator view in UI blocker. Default value is 8.
  public static var DEFAULT_BLOCKER_MESSAGE_SPACING = CGFloat(8.0)
  
  /// Default font of message displayed in UI blocker. Default value is bold system font, size 20.
  public static var DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 20)
  
  /// Default background color of UI blocker. Default value is UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
  public static var DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
  /// Color of activity indicator view.
  @IBInspectable public var color: UIColor = DEFAULT_COLOR
  
  /// Padding of activity indicator view.
  @IBInspectable public var padding: CGFloat = DEFAULT_PADDING
  
  /// Line width of activity indicator view
  @IBInspectable public var lineWidth: CGFloat = DEFAULT_LINE_WIDTH
  
  /// Line cap of activity indicator view
  @IBInspectable public var lineCap: CAShapeLayerLineCap = DEFAULT_LINE_CAP
  
  /// Current status of animation, read-only.
  private(set) public var isAnimating: Bool = false
  
  /**
   Returns an object initialized from data in a given unarchiver.
   self, initialized using the data in decoder.
   
   - parameter decoder: an unarchiver object.
   
   - returns: self, initialized using the data in decoder.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backgroundColor = UIColor.clear
    isHidden = true
  }
  
  /**
   Create a activity indicator view.
   
   Appropriate NVActivityIndicatorView.DEFAULT_* values are used for omitted params.
   
   - parameter frame:   view's frame.
   - parameter type:    animation type.
   - parameter color:   color of activity indicator view.
   - parameter padding: padding of activity indicator view.
   
   - returns: The activity indicator view.
   */
  public init(frame: CGRect, color: UIColor? = nil, padding: CGFloat? = nil, lineWidth: CGFloat? = nil, lineCap: CAShapeLayerLineCap? = nil) {
    self.color = color ?? CircleStrokeSpinner.DEFAULT_COLOR
    self.padding = padding ?? CircleStrokeSpinner.DEFAULT_PADDING
    self.lineWidth = lineWidth ?? CircleStrokeSpinner.DEFAULT_LINE_WIDTH
    self.lineCap = lineCap ?? CircleStrokeSpinner.DEFAULT_LINE_CAP
    super.init(frame: frame)
    isHidden = true
  }
  
  // Fix issue #62
  // Intrinsic content size is used in autolayout
  // that causes mislayout when using with MBProgressHUD.
  /**
   Returns the natural size for the receiving view, considering only properties of the view itself.
   
   A size indicating the natural size for the receiving view based on its intrinsic properties.
   
   - returns: A size indicating the natural size for the receiving view based on its intrinsic properties.
   */
  public override var intrinsicContentSize: CGSize {
    return CGSize(width: bounds.width, height: bounds.height)
  }
  
  public override var bounds: CGRect {
    didSet {
      // setup the animation again for the new bounds
      if oldValue != bounds && isAnimating {
        setUpAnimation()
      }
    }
  }
  
  /**
   Start animating.
   */
  public final func startAnimating() {
    guard !isAnimating else {
      return
    }
    isHidden = false
    isAnimating = true
    layer.speed = 1
    setUpAnimation()
  }
  
  /**
   Stop animating.
   */
  public final func stopAnimating() {
    guard isAnimating else {
      return
    }
    isHidden = true
    isAnimating = false
    layer.sublayers?.removeAll()
  }
  
  // MARK: Privates
  
  private final func setUpAnimation() {
    var animationRect = frame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    let minEdge = min(animationRect.width, animationRect.height)
    
    layer.sublayers = nil
    animationRect.size = CGSize(width: minEdge, height: minEdge)
    setUpCircleStrokeSpinAnimation(in: layer, size: animationRect.size, color: color, lineWidth: lineWidth, lineCap: lineCap)
  }
  
  private final func setUpCircleStrokeSpinAnimation(in layer: CALayer,
                                                    size: CGSize,
                                                    color: UIColor,
                                                    lineWidth: CGFloat,
                                                    lineCap: CAShapeLayerLineCap) {
    let beginTime: Double = 0.5
    let strokeStartDuration: Double = 1.2
    let strokeEndDuration: Double = 0.7
    
    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
    rotationAnimation.byValue = Float.pi * 2
    rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
    
    let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.duration = strokeEndDuration
    strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
    strokeEndAnimation.fromValue = 0
    strokeEndAnimation.toValue = 1
    
    let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
    strokeStartAnimation.duration = strokeStartDuration
    strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
    strokeStartAnimation.fromValue = 0
    strokeStartAnimation.toValue = 1
    strokeStartAnimation.beginTime = beginTime
    
    let groupAnimation = CAAnimationGroup()
    groupAnimation.animations = [rotationAnimation, strokeEndAnimation, strokeStartAnimation]
    groupAnimation.duration = strokeStartDuration + beginTime
    groupAnimation.repeatCount = .infinity
    groupAnimation.isRemovedOnCompletion = false
    groupAnimation.fillMode = .forwards
    
    let stroke = strokeLayer(size: size, color: color, lineWidth: lineWidth, lineCap: lineCap)
    let frame = CGRect(
      x: (layer.bounds.width - size.width) / 2,
      y: (layer.bounds.height - size.height) / 2,
      width: size.width,
      height: size.height
    )
    
    stroke.frame = frame
    stroke.add(groupAnimation, forKey: "animation")
    layer.addSublayer(stroke)
  }
  
  private final func strokeLayer(size: CGSize, color: UIColor, lineWidth: CGFloat, lineCap: CAShapeLayerLineCap) -> CALayer {
    let layer: CAShapeLayer = CAShapeLayer()
    let path: UIBezierPath = UIBezierPath()
    
    path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                radius: size.width / 2,
                startAngle: -(.pi / 2),
                endAngle: .pi + .pi / 2,
                clockwise: true)
    layer.fillColor = nil
    layer.strokeColor = color.cgColor
    layer.lineWidth = lineWidth
    layer.lineCap = lineCap
    
    layer.backgroundColor = nil
    layer.path = path.cgPath
    layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    return layer
  }
}
