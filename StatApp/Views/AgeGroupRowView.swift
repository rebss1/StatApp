//
//  AgeGroupRowView.swift
//  StatApp
//
//  Created by Илья Лощилов on 02.12.2025.
//

import UIKit
import PinLayout

final class AgeGroupRowView: UIView {

    private let titleLabel = UILabel()

    private let firstPercentLabel = UILabel()
    private let secondPercentLabel = UILabel()

    private let firstBarBackgroundView = UIView()
    private let firstBarFillView = UIView()
    private let secondBarBackgroundView = UIView()
    private let secondBarFillView = UIView()

    private var firstPercent: Double = 0
    private var secondPercent: Double = 0

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(titleLabel)

        addSubview(firstBarBackgroundView)
        firstBarBackgroundView.addSubview(firstBarFillView)
        addSubview(firstPercentLabel)

        addSubview(secondBarBackgroundView)
        secondBarBackgroundView.addSubview(secondBarFillView)
        addSubview(secondPercentLabel)

        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .black

        firstPercentLabel.font = .systemFont(ofSize: 12, weight: .regular)
        firstPercentLabel.textColor = .gray

        secondPercentLabel.font = .systemFont(ofSize: 12, weight: .regular)
        secondPercentLabel.textColor = .gray

        firstBarBackgroundView.backgroundColor = .systemGray5
        firstBarBackgroundView.layer.cornerRadius = 2

        secondBarBackgroundView.backgroundColor = .systemGray5
        secondBarBackgroundView.layer.cornerRadius = 2

        firstBarFillView.backgroundColor = .systemRed
        firstBarFillView.layer.cornerRadius = 2

        secondBarFillView.backgroundColor = .systemOrange
        secondBarFillView.layer.cornerRadius = 2

        clipsToBounds = false
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        let horizontalPadding: CGFloat = 0
        let verticalPadding: CGFloat = 8
        let titleWidth: CGFloat = 60
        let barHeight: CGFloat = 4
        let barSpacing: CGFloat = 10
        let percentWidthReserve: CGFloat = 40

        titleLabel.pin
            .top(verticalPadding)
            .left(horizontalPadding)
            .width(titleWidth)
            .height(18)

        let barsLeft = titleLabel.frame.maxX + 16

        firstBarBackgroundView.pin
            .top(verticalPadding + 4)
            .left(barsLeft)
            .right(percentWidthReserve)
            .height(barHeight)

        firstPercentLabel.pin
            .vCenter(to: firstBarBackgroundView.edge.vCenter)
            .left(to: firstBarBackgroundView.edge.right).marginLeft(4)
            .sizeToFit()

        secondBarBackgroundView.pin
            .top(firstBarBackgroundView.frame.maxY + barSpacing)
            .left(barsLeft)
            .right(percentWidthReserve)
            .height(barHeight)

        secondPercentLabel.pin
            .vCenter(to: secondBarBackgroundView.edge.vCenter)
            .left(to: secondBarBackgroundView.edge.right).marginLeft(4)
            .sizeToFit()

        let maxWidth1 = firstBarBackgroundView.bounds.width
        let width1 = maxWidth1 * CGFloat(min(max(firstPercent, 0), 100) / 100.0)
        firstBarFillView.pin
            .left()
            .vCenter()
            .height(barHeight)
            .width(width1)

        let maxWidth2 = secondBarBackgroundView.bounds.width
        let width2 = maxWidth2 * CGFloat(min(max(secondPercent, 0), 100) / 100.0)
        secondBarFillView.pin
            .left()
            .vCenter()
            .height(barHeight)
            .width(width2)
    }

    override var intrinsicContentSize: CGSize {
        let height: CGFloat = 8 + 4 + 10 + 4 + 8
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    // MARK: - Configure

    func configure(title: String, firstPercent: Double, secondPercent: Double) {
        self.firstPercent = firstPercent
        self.secondPercent = secondPercent

        titleLabel.text = title
        firstPercentLabel.text = "\(Int(round(firstPercent)))%"
        secondPercentLabel.text = "\(Int(round(secondPercent)))%"

        setNeedsLayout()
    }
}
