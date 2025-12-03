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
}
