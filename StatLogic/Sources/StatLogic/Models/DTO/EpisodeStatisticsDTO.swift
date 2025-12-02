//
//  EpisodeStatisticsDTO.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

import Foundation

public struct EpisodeStatisticsDTO: Codable {
    public let statistics: [EpisodeStatItemDTO]
}

public struct EpisodeStatItemDTO: Codable {
    public let userId: Int?
    public let type: EpisodeStatType
    public let dates: [Int]

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case type
        case dates
    }
}

public enum EpisodeStatType: String, Codable {
    case view
    case subscription
    case unsubscription
}

extension EpisodeStatisticsDTO {
    func toDomain() -> EpisodeStatistics {
        let views = statistics.filter { $0.type == .view }
        let subs = statistics.filter { $0.type == .subscription }
        let unsubs = statistics.filter { $0.type == .unsubscription }

        let uniqueViewers = Set(views.map { $0.userId })
        let visitorsTotal = uniqueViewers.count

        var perDay: [Int: Int] = [:]
        for item in views {
            for d in item.dates {
                perDay[d, default: 0] += 1
            }
        }

        let sortedDays = perDay.keys.sorted()
        let points: [VisitorsPoint] = sortedDays.enumerated().map { index, dayInt in
            let count = perDay[dayInt] ?? 0
            return VisitorsPoint(x: Double(index), y: Double(count))
        }

        let watchersNew = subs.reduce(0) { $0 + $1.dates.count }
        let watchersLeft = unsubs.reduce(0) { $0 + $1.dates.count }

        return EpisodeStatistics(
            visitorsTotal: visitorsTotal,
            visitorsByDay: points,
            watchersNew: watchersNew,
            watchersLeft: watchersLeft
        )
    }
}
