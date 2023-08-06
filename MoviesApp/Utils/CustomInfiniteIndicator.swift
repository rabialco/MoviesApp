//
//  CustomInfiniteIndicator.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 06/08/23.
//

import UIKit

private let rotationAnimationKey = "rotation"

class CustomInfiniteIndicator: UIView {
    var thickness: CGFloat = 2
    var outerColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    var innerColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    private var animating = false
    private let innerCircle = CAShapeLayer()
    private let outerCircle = CAShapeLayer()

    // MARK: - Public

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    deinit {
        unregisterFromAppStateNotifications()
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        setupBezierPaths()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        if let _ = window {
            restartAnimationIfNeeded()
        }
    }

    override func tintColorDidChange() {
        if innerColor == nil {
            updateColors()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, tvOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateColors()
            }
        }
    }

    func isAnimating() -> Bool {
        return animating
    }

    @objc func startAnimating() {
        guard !animating else { return }
        animating = true
        isHidden = false
        addAnimation()
    }

    @objc func stopAnimating() {
        guard animating else { return }
        animating = false
        isHidden = true
        removeAnimation()
    }

    // MARK: - Private

    private func commonInit() {
        registerForAppStateNotifications()

        isHidden = true
        backgroundColor = UIColor.clear

        outerCircle.fillColor = UIColor.clear.cgColor
        outerCircle.lineWidth = thickness

        innerCircle.fillColor = UIColor.clear.cgColor
        innerCircle.lineWidth = thickness

        updateColors()

        layer.addSublayer(outerCircle)
        layer.addSublayer(innerCircle)
    }

    private func updateColors() {
        let outerColor = outerColor ?? defaultOuterColor()
        let innerColor = innerColor ?? tintColor

        outerCircle.strokeColor = outerColor.cgColor
        innerCircle.strokeColor = innerColor?.cgColor
    }

    private func addAnimation() {
        let anim = animation()

        anim.timeOffset = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.add(anim, forKey: rotationAnimationKey)
    }

    private func removeAnimation() {
        layer.removeAnimation(forKey: rotationAnimationKey)
    }

    @objc func restartAnimationIfNeeded() {
        let anim = layer.animation(forKey: rotationAnimationKey)

        if animating, anim == nil {
            removeAnimation()
            addAnimation()
        }
    }

    private func registerForAppStateNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(CustomInfiniteIndicator.restartAnimationIfNeeded),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    private func unregisterFromAppStateNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    private func animation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = NSNumber(value: Double.pi * 2)
        animation.duration = 1
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        return animation
    }

    private func setupBezierPaths() {
        let center = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        let radius = bounds.size.width * 0.5 - thickness
        let ringPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: CGFloat(0),
            endAngle: CGFloat.pi * 2,
            clockwise: true
        )
        let quarterRingPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 4,
            endAngle: CGFloat.pi / 2 - CGFloat.pi / 4,
            clockwise: true
        )

        outerCircle.path = ringPath.cgPath
        innerCircle.path = quarterRingPath.cgPath
    }

    private func defaultOuterColor() -> UIColor {
        if #available(iOS 13.0, tvOS 13, *) {
            return .white
        } else {
            return .white.withAlphaComponent(0.2)
        }
    }
}
