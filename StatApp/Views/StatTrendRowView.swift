//
//  StatTrendRowView.swift
//  StatApp
//
//  Created by Илья Лощилов on 02.12.2025.
//

import UIKit
import PinLayout

final class StatTrendRowView: UIView {

    private let sparklineView = SparklineChartView()
    private let valueLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(sparklineView)
        addSubview(valueLabel)
        addSubview(arrowImageView)
        addSubview(descriptionLabel)

        sparklineView.backgroundColor = .clear

        valueLabel.font = .systemFont(ofSize: 24, weight: .bold)
        valueLabel.textColor = .black

        arrowImageView.contentMode = .scaleAspectFit

        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 2
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        sparklineView.pin
            .vCenter().left(16)
            .width(80).height(50)

        valueLabel.pin
            .top(16)
            .left(to: sparklineView.edge.right).marginLeft(16)
            .sizeToFit()

        arrowImageView.pin
            .vCenter(to: valueLabel.edge.vCenter)
            .left(to: valueLabel.edge.right).marginLeft(6)
            .width(12).height(12)

        descriptionLabel.pin
            .below(of: valueLabel, aligned: .left)
            .marginTop(4)
            .right(16)
            .sizeToFit(.width)
    }

    func configure(
        value: Int,
        sparklineValues: [Double],
        color: UIColor,
        description: String
    ) {
        valueLabel.text = "\(value)"
        if color == .systemRed {
            arrowImageView.image = UIImage(systemName: "arrow.down")
        } else {
            arrowImageView.image = UIImage(systemName: "arrow.up")
        }
        arrowImageView.tintColor = color
        descriptionLabel.text = description
        sparklineView.configure(values: sparklineValues, color: color)
    }

    func setShowsSeparator(_ show: Bool) {
        setNeedsLayout()
    }
}
