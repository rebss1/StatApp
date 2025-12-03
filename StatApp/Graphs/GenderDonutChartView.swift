//
//  GenderDonutChartView.swift
//  StatApp
//
//  Created by Илья Лощилов on 02.12.2025.
//

import UIKit
import DGCharts
import StatLogic

final class GenderDonutChartView: UIView {

    private let chartView = PieChartView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChart()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupChart()
    }

    private func setupChart() {
        addSubview(chartView)

        chartView.chartDescription.enabled = false
        chartView.legend.enabled = false
        chartView.drawEntryLabelsEnabled = false

        chartView.holeRadiusPercent = 0.65
        chartView.transparentCircleRadiusPercent = 0.7
        chartView.drawHoleEnabled = true

        chartView.rotationAngle = 270        
        chartView.rotationEnabled = false
        chartView.highlightPerTapEnabled = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
    }

    func configure(shares: [GenderShare]) {
        let entries = shares.map {
            PieChartDataEntry(value: $0.value, label: $0.label)
        }

        let set = PieChartDataSet(entries: entries, label: "")
        set.drawValuesEnabled = false
        set.selectionShift = 0
        set.colors = shares.map { $0.color }

        let data = PieChartData(dataSet: set)
        chartView.data = data
        chartView.animate(xAxisDuration: 0.3, yAxisDuration: 0.3)
    }
}
