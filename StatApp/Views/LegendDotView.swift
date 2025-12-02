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

    private let hStack = UIStackView()

    init(title: String) {
        super.init(frame: .zero)
        setup()
        titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        hStack.axis = .horizontal
        hStack.spacing = 4
        hStack.alignment = .center

        dotView.layer.cornerRadius = 4
        dotView.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        percentLabel.font = .systemFont(ofSize: 12, weight: .regular)
        percentLabel.textColor = .gray

        addSubview(hStack)
        hStack.addArrangedSubview(dotView)
        hStack.addArrangedSubview(titleLabel)
        hStack.addArrangedSubview(percentLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        hStack.pin.all()
        dotView.pin.width(8).height(8)
    }

    func update(percent: Double, color: UIColor) {
        dotView.backgroundColor = color
        percentLabel.text = "\(Int(percent))%"
    }
}
