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

        // Общий стиль
        chartView.chartDescription.enabled = false
        chartView.legend.enabled = false  // легенда не нужна  [oai_citation:2‡Stack Overflow](https://stackoverflow.com/questions/36713996/how-to-hide-labels-in-ios-charts?utm_source=chatgpt.com)
        chartView.rightAxis.enabled = false

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false

        let leftAxis = chartView.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridLineWidth = 0.5
        leftAxis.axisMinimum = 0

        // Жесты
        chartView.doubleTapToZoomEnabled = false
        chartView.setScaleEnabled(false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds   // или chartView.pin.all()
    }

    func configure(points: [VisitorsPoint]) {
        let entries = points.map { ChartDataEntry(x: $0.x, y: $0.y) }

        let set = LineChartDataSet(entries: entries, label: "") // линия графика  [oai_citation:3‡Medium](https://medium.com/%40OsianSmith/creating-a-line-chart-in-swift-3-and-ios-10-2f647c95392e?utm_source=chatgpt.com)
        set.mode = .cubicBezier
        set.lineWidth = 2
        set.drawCirclesEnabled = true
        set.circleRadius = 3
        set.drawValuesEnabled = false
        set.colors = [.systemRed]
        set.circleColors = [.systemRed]

        let data = LineChartData(dataSet: set)
        chartView.data = data
        chartView.animate(xAxisDuration: 0.3, yAxisDuration: 0.3)
    }
}
