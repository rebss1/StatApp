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
        addSubview(firstPercentLabel)
        addSubview(secondPercentLabel)
        
        addSubview(firstBarBackgroundView)
        addSubview(secondBarBackgroundView)
        
        firstBarBackgroundView.addSubview(firstBarFillView)
        secondBarBackgroundView.addSubview(secondBarFillView)
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .black
        
        firstPercentLabel.font = .systemFont(ofSize: 12, weight: .regular)
        firstPercentLabel.textColor = .gray
        
        secondPercentLabel.font = .systemFont(ofSize: 12, weight: .regular)
        secondPercentLabel.textColor = .gray
        
        firstBarBackgroundView.backgroundColor = UIColor.systemGray5
        firstBarBackgroundView.layer.cornerRadius = 2
        
        secondBarBackgroundView.backgroundColor = UIColor.systemGray5
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
        
        let titleWidth: CGFloat = 60
        
        titleLabel.pin
            .top(0)
            .left(0)
            .width(titleWidth)
            .height(18)
        
        firstPercentLabel.pin
            .top(0)
            .right(0)
            .sizeToFit(.width)
            .height(16)
        
        secondPercentLabel.pin
            .below(of: firstPercentLabel)
            .marginTop(4)
            .right(0)
            .sizeToFit(.width)
            .height(16)
        
        firstBarBackgroundView.pin
            .vCenter(to: firstPercentLabel.edge.vCenter)
            .left(to: titleLabel.edge.right).marginLeft(16)
            .right(to: firstPercentLabel.edge.left).marginRight(8)
            .height(4)
        
        secondBarBackgroundView.pin
            .vCenter(to: secondPercentLabel.edge.vCenter)
            .left(to: titleLabel.edge.right).marginLeft(16)
            .right(to: secondPercentLabel.edge.left).marginRight(8)
            .height(4)
            .bottom(0)
        
        let maxWidth1 = firstBarBackgroundView.bounds.width
        let width1 = maxWidth1 * CGFloat(min(max(firstPercent, 0), 100) / 100.0)
        firstBarFillView.pin
            .left()
            .vCenter()
            .height(4)
            .width(width1)
        
        let maxWidth2 = secondBarBackgroundView.bounds.width
        let width2 = maxWidth2 * CGFloat(min(max(secondPercent, 0), 100) / 100.0)
        secondBarFillView.pin
            .left()
            .vCenter()
            .height(4)
            .width(width2)
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 40)
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
