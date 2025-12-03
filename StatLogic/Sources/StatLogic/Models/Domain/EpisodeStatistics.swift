//
//  EpisodeStatistics.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

import Foundation

public struct EpisodeStatistics {
    public let visitorsTotal: Int
    public let dailyPoints: [VisitorsPoint]
    public let weeklyPoints: [VisitorsPoint]
    public let monthlyPoints: [VisitorsPoint]
    public let watchersNew: Int
    public let watchersLeft: Int
    public let viewsByUser: [Int: [Date]]

    public init(
        visitorsTotal: Int,
        dailyPoints: [VisitorsPoint],
        weeklyPoints: [VisitorsPoint],
        monthlyPoints: [VisitorsPoint],
        watchersNew: Int,
        watchersLeft: Int,
        viewsByUser: [Int: [Date]]
    ) {
        self.visitorsTotal = visitorsTotal
        self.dailyPoints = dailyPoints
        self.weeklyPoints = weeklyPoints
        self.monthlyPoints = monthlyPoints
        self.watchersNew = watchersNew
        self.watchersLeft = watchersLeft
        self.viewsByUser = viewsByUser
    }
}
