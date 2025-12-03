//
//  TopVisitorRowView.swift
//  StatApp
//
//  Created by Илья Лощилов on 02.12.2025.
//

import UIKit
import PinLayout

final class TopVisitorRowView: UIView {

    private let avatarView = UIView()
    private let initialsLabel = UILabel()
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let chevronView = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(avatarView)
        avatarView.addSubview(initialsLabel)
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(chevronView)

        avatarView.backgroundColor = UIColor.systemGray5
        avatarView.layer.cornerRadius = 20
        avatarView.clipsToBounds = true

        initialsLabel.font = .systemFont(ofSize: 14, weight: .medium)
        initialsLabel.textAlignment = .center
        initialsLabel.textColor = .darkGray

        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        ageLabel.font = .systemFont(ofSize: 14, weight: .regular)
        ageLabel.textColor = .gray

        chevronView.tintColor = .lightGray
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        avatarView.pin
            .vCenter()
            .left(16)
            .width(40)
            .height(40)

        initialsLabel.pin.all()

        chevronView.pin
            .vCenter()
            .right(16)
            .sizeToFit()

        nameLabel.pin
            .top(8)
            .left(to: avatarView.edge.right).marginLeft(12)
            .right(to: chevronView.edge.left).marginRight(8)
            .height(20)

        ageLabel.pin
            .below(of: nameLabel, aligned: .left)
            .marginTop(2)
            .right(to: chevronView.edge.left).marginRight(8)
            .height(18)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 64)
    }

    func configure(name: String, age: Int?) {
        nameLabel.text = name
        if let age = age {
            ageLabel.text = "\(age) лет"
        } else {
            ageLabel.text = nil
        }
        initialsLabel.text = String(name.prefix(1)).uppercased()
    }
}
