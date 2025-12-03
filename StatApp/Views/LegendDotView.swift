//
//  LegendDotView.swift
//  StatApp
//
//  Created by Илья Лощилов on 02.12.2025.
//

import UIKit
import PinLayout

final class LegendDotView: UIView {

    private let dotView = UIView()
    private let titleLabel = UILabel()
    private let percentLabel = UILabel()

    // MARK: - Init

    init(title: String) {
        super.init(frame: .zero)
        setup()
        titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(dotView)
        addSubview(titleLabel)
        addSubview(percentLabel)

        dotView.layer.cornerRadius = 4
        dotView.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = .black

        percentLabel.font = .systemFont(ofSize: 12, weight: .regular)
        percentLabel.textColor = .gray
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        let dotSize: CGFloat = 8

        dotView.pin
            .vCenter()
            .left(0)
            .width(dotSize)
            .height(dotSize)

        titleLabel.pin
            .left(to: dotView.edge.right).marginLeft(4)
            .vCenter()
            .sizeToFit()

        percentLabel.pin
            .left(to: titleLabel.edge.right).marginLeft(4)
            .vCenter()
            .sizeToFit()            
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 20)
    }

    // MARK: - Public

    func update(percent: Double, color: UIColor) {
        dotView.backgroundColor = color
        percentLabel.text = "\(Int(round(percent)))%"
        setNeedsLayout()
    }
}
