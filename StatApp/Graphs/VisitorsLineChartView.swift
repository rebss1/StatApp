//
//  VisitorsLineChartView.swift
//  StatApp
//
//  Created by Илья Лощилов on 02.12.2025.
//

import UIKit
import DGCharts
import StatLogic

final class VisitorsLineChartView: UIView {

    private let chartView = LineChartView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChart()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupChart()
    }

    // MARK: - Setup

    private func setupChart() {
        addSubview(chartView)

        backgroundColor = .clear
        chartView.backgroundColor = .clear

        chartView.chartDescription.enabled = false
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.setScaleEnabled(false)

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = true
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
        xAxis.axisMinimum = 0
        xAxis.valueFormatter = DefaultAxisValueFormatter(decimals: 0)

        let leftAxis = chartView.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridLineWidth = 0.5
        leftAxis.axisMinimum = 0
        leftAxis.granularityEnabled = true
        leftAxis.granularity = 1
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
    }

    // MARK: - Public

    func configure(points: [VisitorsPoint]) {
        guard !points.isEmpty else {
            chartView.data = nil
            return
        }

        let entries: [ChartDataEntry] = points.enumerated().map { index, point in
            ChartDataEntry(x: Double(index), y: point.y)
        }

        let dataSet = LineChartDataSet(entries: entries, label: "")
        dataSet.mode = LineChartDataSet.Mode.cubicBezier
        dataSet.lineWidth = 2
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 3
        dataSet.drawValuesEnabled = false
        dataSet.setColor(UIColor.systemRed)
        dataSet.setCircleColor(UIColor.systemRed)

        let data = LineChartData(dataSet: dataSet)
        chartView.data = data

        let maxX = Double(points.count - 1)
        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = maxX

        if let maxY = points.map({ $0.y }).max() {
            let top = max(maxY, 1)
            chartView.leftAxis.axisMaximum = ceil(top)
        }

        chartView.notifyDataSetChanged()
        chartView.animate(xAxisDuration: 0.25, yAxisDuration: 0.25)
    }
}
