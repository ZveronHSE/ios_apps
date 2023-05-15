//
//  ShadowCardView.swift
//  SpecialistApp
//
//  Created by alexander on 11.04.2023.
//

import Foundation
import UIKit

class ShadowCardView: UIView {

    private var settings: ViewSettings!

    var onClick: (() -> Void)?

    private lazy var shadowLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()

    lazy var contentView: UIButton = {
        let view = UIButton(type: .system)
        view.addTarget(self, action: #selector(performClick), for: .touchDown)
        view.addTarget(self, action: #selector(clickOnView), for: .touchUpInside)
        view.addTarget(self, action: #selector(clickOutView), for: .touchUpOutside)
        return view
    }()

    lazy var contentView1: UIView = {
        let view = UIView()
        return view
    }()

    private init() { super.init(frame: .zero) }

    public init(with settings: ViewSettings) {
        super.init(frame: .zero)
        self.settings = settings
        layer.addSublayer(shadowLayer)
        addSubview(contentView)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        shadowLayer.frame = bounds
        shadowLayer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: settings.cornerRadius).cgPath
        shadowLayer.shadowOpacity = settings.shadowOpacity
        shadowLayer.shadowColor = settings.shadowColor
        shadowLayer.shadowRadius = settings.shadowRadius
        shadowLayer.shadowOffset = CGSize(width: 0, height: settings.shadowOffsetHeight)

        contentView.frame = bounds
        contentView.layer.cornerRadius = settings.cornerRadius
        contentView.backgroundColor = .zvWhite
        contentView.clipsToBounds = true
    }

    @objc private func performClick() { contentView.select(animated: true) }

    @objc private func clickOutView() { contentView.unselect(animated: true) }

    @objc private func clickOnView() { contentView.unselect(animated: true); onClick?() }
}

internal struct ViewSettings {
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let shadowColor: CGColor
    let shadowOpacity: Float
    let shadowOffsetHeight: CGFloat

    init(
        cornerRadius: CGFloat,
        shadowRadius: CGFloat,
        shadowColor: CGColor = UIColor.zvBlack.withAlphaComponent(0.03).cgColor,
        shadowOpacity: Float = 1,
        shadowOffsetHeight: CGFloat = 4
    ) {
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowOffsetHeight = shadowOffsetHeight
    }
}
