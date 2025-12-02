//
//  SparklineChartView.swift
//  StatApp
//
//  Created by Илья Лощилов on 02.12.2025.
//

import UIKit
import DGCharts

final class SparklineChartView: UIView {

    private let chartView = LineChartView()

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

        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false

        chartView.xAxis.enabled = false

        chartView.drawGridBackgroundEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.setScaleEnabled(false)
        chartView.highlightPerTapEnabled = false
        chartView.highlightPerDragEnabled = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
    }

    func configure(values: [Double], color: UIColor) {
        let entries = values.enumerated().map { index, value in
            ChartDataEntry(x: Double(index), y: value)
        }

        let set = LineChartDataSet(entries: entries, label: "")
        set.mode = .cubicBezier
        set.lineWidth = 2
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        set.colors = [color]

        let data = LineChartData(dataSet: set)
        chartView.data = data
        chartView.animate(xAxisDuration: 0.25, yAxisDuration: 0.25)
    }
}
