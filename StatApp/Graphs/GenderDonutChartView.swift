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
        chartView.legend.enabled = false     // легенда не нужна
        chartView.drawEntryLabelsEnabled = false // убираем подписи на сегментах  [oai_citation:6‡Stack Overflow](https://stackoverflow.com/questions/36713996/how-to-hide-labels-in-ios-charts?utm_source=chatgpt.com)

        chartView.holeRadiusPercent = 0.65   // превращаем Pie в donut
        chartView.transparentCircleRadiusPercent = 0.7
        chartView.drawHoleEnabled = true

        chartView.rotationAngle = 270        // чтобы начало было сверху
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
