//
//  StatisticsViewController.swift
//  StatApp
//
//  Created by Илья Лощилов on 02.12.2025.
//

import StatLogic
import UIKit
import RxSwift
import PinLayout

private enum GenderColors {
    static let male = UIColor(red: 0.99, green: 0.27, blue: 0.23, alpha: 1.0)
    static let female = UIColor(red: 1.00, green: 0.73, blue: 0.43, alpha: 1.0)
}

final class StatisticsViewController: UIViewController {

    // MARK: - Dependencies

    private let manager: EpisodeStatisticsManaging
    private let disposeBag = DisposeBag()

    // MARK: - Root UI

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let refreshControl = UIRefreshControl()

    // MARK: - Visitors section

    private let visitorsSectionTitleLabel = UILabel()
    private let visitorsCardView = UIView()
    private let visitorsRowView = StatTrendRowView()

    private let visitorsPeriodSegmented = UISegmentedControl(
        items: ["По дням", "По неделям", "По месяцам"]
    )
    private let visitorsLineCardView = UIView()
    private let visitorsLineChartView = VisitorsLineChartView()

    // MARK: - Top visitors section

    private let topVisitorsTitleLabel = UILabel()
    private let topVisitorsCardView = UIView()
    private let topVisitorsStackView = UIStackView()

    // MARK: - Gender & age section

    private let genderAgeTitleLabel = UILabel()
    private let genderPeriodSegmented = UISegmentedControl(
        items: ["Сегодня", "Неделя", "Месяц", "Все время"]
    )
    private let genderAgeCardView = UIView()
    private let genderDonutView = GenderDonutChartView()
    private let genderLegendStackView = UIStackView()
    private let maleLegendView = LegendDotView(title: "Мужчины")
    private let femaleLegendView = LegendDotView(title: "Женщины")
    private let genderDividerView = UIView()

    private let ageStackView = UIStackView()

    // MARK: - Watchers section

    private let watchersTitleLabel = UILabel()
    private let watchersCardView = UIView()
    private let watchersNewRow = StatTrendRowView()
    private let watchersLeftRow = StatTrendRowView()
    private let watchersSeparatorView = UIView()

    // MARK: - Init

    init() {
        let apiClient = APIClient()
        let realmProvider = RealmProvider()
        self.manager = EpisodeStatisticsManager(
            apiClient: apiClient,
            realmProvider: realmProvider
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupHierarchy()
        setupStyles()

        loadData(forceRefresh: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layout()
    }

    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        title = "Статистика"
        navigationController?.navigationBar.prefersLargeTitles = true

        scrollView.alwaysBounceVertical = true
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(visitorsSectionTitleLabel)
        contentView.addSubview(visitorsCardView)
        visitorsCardView.addSubview(visitorsRowView)

        contentView.addSubview(visitorsPeriodSegmented)
        contentView.addSubview(visitorsLineCardView)
        visitorsLineCardView.addSubview(visitorsLineChartView)

        contentView.addSubview(topVisitorsTitleLabel)
        contentView.addSubview(topVisitorsCardView)
        topVisitorsCardView.addSubview(topVisitorsStackView)

        contentView.addSubview(genderAgeTitleLabel)
        contentView.addSubview(genderPeriodSegmented)
        contentView.addSubview(genderAgeCardView)
        genderAgeCardView.addSubview(genderDonutView)
        genderAgeCardView.addSubview(genderLegendStackView)
        genderLegendStackView.addArrangedSubview(maleLegendView)
        genderLegendStackView.addArrangedSubview(femaleLegendView)
        genderAgeCardView.addSubview(genderDividerView)
        genderAgeCardView.addSubview(ageStackView)

        contentView.addSubview(watchersTitleLabel)
        contentView.addSubview(watchersCardView)
        watchersCardView.addSubview(watchersNewRow)
        watchersCardView.addSubview(watchersLeftRow)
        watchersCardView.addSubview(watchersSeparatorView)

        topVisitorsStackView.axis = .vertical
        topVisitorsStackView.spacing = 0

        ageStackView.axis = .vertical
        ageStackView.spacing = 8

        genderLegendStackView.axis = .horizontal
        genderLegendStackView.spacing = 16
        genderLegendStackView.distribution = .fillProportionally
    }

    private func setupStyles() {
        [visitorsCardView,
         visitorsLineCardView,
         topVisitorsCardView,
         genderAgeCardView,
         watchersCardView].forEach { card in
            card.backgroundColor = .white
            card.layer.cornerRadius = 16
            card.layer.masksToBounds = false
            card.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
            card.layer.shadowOffset = CGSize(width: 0, height: 4)
            card.layer.shadowRadius = 8
            card.layer.shadowOpacity = 1
        }

        visitorsSectionTitleLabel.text = "Посетители"
        visitorsSectionTitleLabel.font = .systemFont(ofSize: 20, weight: .semibold)


        visitorsPeriodSegmented.selectedSegmentIndex = 0

        topVisitorsTitleLabel.text = "Чаще всех посещают ваш профиль"
        topVisitorsTitleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        topVisitorsTitleLabel.numberOfLines = 0

        genderAgeTitleLabel.text = "Пол и возраст"
        genderAgeTitleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        genderAgeTitleLabel.numberOfLines = 0

        genderDividerView.backgroundColor = UIColor.systemGray5
        genderPeriodSegmented.selectedSegmentIndex = 0

        watchersTitleLabel.text = "Наблюдатели"
        watchersTitleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        watchersTitleLabel.numberOfLines = 0
        watchersSeparatorView.backgroundColor = .systemGray5
    }

    // MARK: - Layout

    private func layout() {
        scrollView.pin.all()
        contentView.pin.top().horizontally().width(of: scrollView)

        var y: CGFloat = 16

        visitorsSectionTitleLabel.pin
            .top(y)
            .horizontally(16)
            .sizeToFit(.width)
        y = visitorsSectionTitleLabel.frame.maxY + 12

        visitorsCardView.pin
            .top(y)
            .horizontally(16)
            .height(100)
        layoutVisitorsCard()
        y = visitorsCardView.frame.maxY + 16

        visitorsPeriodSegmented.pin
            .top(y)
            .horizontally(16)
            .height(32)
        y = visitorsPeriodSegmented.frame.maxY + 12

        visitorsLineCardView.pin
            .top(y)
            .horizontally(16)
            .height(200)
        visitorsLineChartView.pin.all(16)
        y = visitorsLineCardView.frame.maxY + 24

        topVisitorsTitleLabel.pin
            .top(y)
            .horizontally(16)
            .sizeToFit(.width)
        y = topVisitorsTitleLabel.frame.maxY + 12

        topVisitorsCardView.pin
            .top(y)
            .horizontally(16)

        topVisitorsStackView.pin
            .top(12)
            .horizontally(0)

        var topInnerY: CGFloat = 0
        for view in topVisitorsStackView.subviews {
            if view is TopVisitorRowView {
                view.pin
                    .top(topInnerY)
                    .horizontally(0)
                    .height(56)
            } else {
                view.pin
                    .top(topInnerY)
                    .horizontally(0)
                    .height(1)
            }
            topInnerY = view.frame.maxY
        }

        topVisitorsStackView.pin.height(topInnerY)

        let topCardHeight = topVisitorsStackView.frame.maxY + 12
        topVisitorsCardView.pin
            .height(topCardHeight)

        y = topVisitorsCardView.frame.maxY + 24

        genderAgeTitleLabel.pin
            .top(y).horizontally(16)
            .sizeToFit(.width)
        y = genderAgeTitleLabel.frame.maxY + 12

        genderPeriodSegmented.pin
            .top(y).horizontally(16)
            .height(32)
        y = genderPeriodSegmented.frame.maxY + 12

        genderAgeCardView.pin
            .top(y)
            .horizontally(16)

        genderDonutView.pin
            .top(20)
            .hCenter()
            .width(151)
            .height(151)

        genderLegendStackView.pin
            .below(of: genderDonutView)
            .marginTop(12)
            .horizontally(32)
            .height(20)

        genderDividerView.pin
            .below(of: genderLegendStackView)
            .marginTop(16)
            .horizontally(0)
            .height(1)

        ageStackView.pin
            .below(of: genderDividerView)
            .marginTop(16)
            .horizontally(16)

        var ageInnerY: CGFloat = 0
        for row in ageStackView.subviews {
            let rowHeight = row.intrinsicContentSize.height
            row.pin
                .top(ageInnerY)
                .horizontally(0)
                .height(rowHeight)
            ageInnerY = row.frame.maxY + 8
        }

        ageStackView.pin.height(ageInnerY)

        genderAgeCardView.pin
            .height(ageStackView.frame.maxY + 16)

        y = genderAgeCardView.frame.maxY + 24

        watchersTitleLabel.pin
            .top(y).horizontally(16)
            .sizeToFit(.width)
        y = watchersTitleLabel.frame.maxY + 12

        watchersCardView.pin
            .top(y).horizontally(16)
            .height(200)

        // Верхняя строка
        watchersNewRow.pin
            .top(0)
            .horizontally(0)
            .height(100)

        // Разделитель на всю ширину карточки
        watchersSeparatorView.pin
            .below(of: watchersNewRow)
            .horizontally(0)
            .height(1)

        // Нижняя строка
        watchersLeftRow.pin
            .below(of: watchersSeparatorView)
            .horizontally(0)
            .bottom(0)

        y = watchersCardView.frame.maxY + 32

        contentView.pin.height(y)
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: y)
    }

    private func layoutVisitorsCard() {
        visitorsRowView.pin.all()
    }

    // MARK: - Actions

    @objc private func handleRefresh() {
        loadData(forceRefresh: true)
    }

    // MARK: - Data

    private func loadData(forceRefresh: Bool) {
        refreshControl.beginRefreshing()

        Single.zip(
            manager.loadStatistics(forceRefresh: forceRefresh),
            manager.loadUsers(forceRefresh: forceRefresh)
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] stats, users in
            guard let self else { return }
            self.refreshControl.endRefreshing()
            self.apply(stats: stats, users: users)
        }, onFailure: { [weak self] error in
            self?.refreshControl.endRefreshing()
            print("Failed to load data:", error)
        })
        .disposed(by: disposeBag)
    }

    private func apply(stats: EpisodeStatistics, users: [EpisodeUser]) {
        let visitorsValues = stats.visitorsByDay.map { $0.y }
        let (trendText, trendColor) = visitorsTrendDescriptionAndColor(stats: stats)
        visitorsRowView.configure(
            value: stats.visitorsTotal,
            sparklineValues: visitorsValues,
            color: trendColor,
            description: trendText
        )
        visitorsLineChartView.configure(points: stats.visitorsByDay)

        let maleCount = users.filter { $0.sex == "M" }.count
        let femaleCount = users.filter { $0.sex == "W" }.count
        let totalGender = maleCount + femaleCount

        let malePercent = totalGender > 0
            ? Double(maleCount) / Double(totalGender) * 100.0
            : 0
        let femalePercent = totalGender > 0
            ? Double(femaleCount) / Double(totalGender) * 100.0
            : 0

        genderDonutView.configure(
            shares: [
                GenderShare(value: malePercent, label: "Мужчины", color: GenderColors.male),
                GenderShare(value: femalePercent, label: "Женщины", color: GenderColors.female)
            ]
        )
        maleLegendView.update(percent: malePercent, color: GenderColors.male)
        femaleLegendView.update(percent: femalePercent, color: GenderColors.female)

        ageStackView.subviews.forEach { $0.removeFromSuperview() }

        // Пользователи с известным возрастом
        let usersWithAge = users.filter { $0.age != nil }

        // Диапазоны возрастов, как в дизайне
        let ageRanges: [(title: String, range: ClosedRange<Int>)] = [
            ("18-21", 18...21),
            ("22-25", 22...25),
            ("26-30", 26...30),
            ("31-35", 31...35),
            ("36-40", 36...40),
            ("40-50", 40...50),
            (">50", 51...150)
        ]

        // Общее количество мужчин и женщин с возрастом — чтобы проценты в сумме давали 100% по каждому полу
        let totalMalesWithAge = usersWithAge.filter { $0.sex == "M" }.count
        let totalFemalesWithAge = usersWithAge.filter { $0.sex == "W" }.count

        for item in ageRanges {
            let usersInRange = usersWithAge.filter { user in
                guard let age = user.age else { return false }
                return item.range.contains(age)
            }

            let malesInRange = usersInRange.filter { $0.sex == "M" }.count
            let femalesInRange = usersInRange.filter { $0.sex == "W" }.count

            let malePercent: Double
            if totalMalesWithAge > 0 {
                malePercent = Double(malesInRange) / Double(totalMalesWithAge) * 100.0
            } else {
                malePercent = 0
            }

            let femalePercent: Double
            if totalFemalesWithAge > 0 {
                femalePercent = Double(femalesInRange) / Double(totalFemalesWithAge) * 100.0
            } else {
                femalePercent = 0
            }

            let row = AgeGroupRowView()
            row.configure(
                title: item.title,
                firstPercent: malePercent,
                secondPercent: femalePercent
            )
            ageStackView.addSubview(row)
        }

        watchersNewRow.configure(
            value: stats.watchersNew,
            sparklineValues: sparklineValues(base: stats.watchersNew),
            color: .systemGreen,
            description: "Новые наблюдатели"
        )

        watchersLeftRow.configure(
            value: stats.watchersLeft,
            sparklineValues: sparklineValues(base: stats.watchersLeft),
            color: .systemRed,
            description: "Пользователи перестали за вами наблюдать"
        )

        topVisitorsStackView.subviews.forEach { $0.removeFromSuperview() }

        let topUsers = Array(users.prefix(3))
        for (index, user) in topUsers.enumerated() {
            let row = TopVisitorRowView()
            row.configure(name: user.name, age: user.age)
            topVisitorsStackView.addSubview(row)
            if index < topUsers.count - 1 {
                let separator = UIView()
                separator.backgroundColor = .systemGray5
                topVisitorsStackView.addSubview(separator)
            }
        }

        view.setNeedsLayout()
    }

    private func visitorsTrendDescriptionAndColor(stats: EpisodeStatistics) -> (String, UIColor) {
        guard
            let first = stats.visitorsByDay.first?.y,
            let last = stats.visitorsByDay.last?.y,
            first > 0
        else {
            return ("Количество посетителей не изменилось", .gray)
        }

        let diff = last - first
        let percent = Int(round(diff / first * 100))

        if percent > 0 {
            return ("Количество посетителей выросло на \(percent)%", .systemGreen)
        } else if percent < 0 {
            return ("Количество посетителей уменьшилось на \(abs(percent))%", .systemRed)
        } else {
            return ("Количество посетителей не изменилось", .gray)
        }
    }

    private func sparklineValues(base: Int) -> [Double] {
        guard base > 0 else { return [0, 0, 0, 0, 0] }
        let b = Double(base)
        return [0.6*b, 0.8*b, b, 0.7*b, 1.1*b]
    }
}
