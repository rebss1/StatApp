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

extension EpisodeStatisticsDTO {
    func toDomain() -> EpisodeStatistics {
        let calendar = Calendar(identifier: .gregorian)

        func parseDate(_ value: Int) -> Date? {
            let string = String(value)
            guard string.count >= 7 else { return nil }

            let yearStr  = String(string.suffix(4))
            let monthStr = String(string.dropLast(4).suffix(2))
            let dayStr   = String(string.dropLast(6))

            guard
                let year = Int(yearStr),
                let month = Int(monthStr),
                let day = Int(dayStr)
            else { return nil }

            var comps = DateComponents()
            comps.year = year
            comps.month = month
            comps.day = day
            return calendar.date(from: comps)
        }

        let viewItems = statistics.filter { $0.type == .view }
        let subs = statistics.filter { $0.type == .subscription }
        let unsubs = statistics.filter { $0.type == .unsubscription }

        var viewsByUser: [Int: [Date]] = [:]
        var dayUsers: [Date: Set<Int>] = [:]

        for item in viewItems {
            guard let userId = item.userId else { continue }

            for intDate in item.dates {
                guard let date = parseDate(intDate) else { continue }
                let day = calendar.startOfDay(for: date)

                viewsByUser[userId, default: []].append(date)
                dayUsers[day, default: []].insert(userId)
            }
        }

        let uniqueViewers: Set<Int> = Set(viewsByUser.keys)
        let visitorsTotal = uniqueViewers.count

        let sortedDays = dayUsers.keys.sorted()
        let dailyPoints: [VisitorsPoint] = sortedDays.enumerated().map { index, day in
            let count = dayUsers[day]?.count ?? 0
            return VisitorsPoint(x: Double(index), y: Double(count))
        }

        var weekUsers: [Int: Set<Int>] = [:]
        for (day, users) in dayUsers {
            let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: day)
            guard
                let year = comps.yearForWeekOfYear,
                let week = comps.weekOfYear
            else { continue }

            let key = year * 100 + week
            if var existing = weekUsers[key] {
                existing.formUnion(users)
                weekUsers[key] = existing
            } else {
                weekUsers[key] = users
            }
        }

        let sortedWeeks = weekUsers.keys.sorted()
        let weeklyPoints: [VisitorsPoint] = sortedWeeks.enumerated().map { index, key in
            let count = weekUsers[key]?.count ?? 0
            return VisitorsPoint(x: Double(index), y: Double(count))
        }

        var monthUsers: [Int: Set<Int>] = [:]
        for (day, users) in dayUsers {
            let comps = calendar.dateComponents([.year, .month], from: day)
            guard
                let year = comps.year,
                let month = comps.month
            else { continue }

            let key = year * 100 + month
            if var existing = monthUsers[key] {
                existing.formUnion(users)
                monthUsers[key] = existing
            } else {
                monthUsers[key] = users
            }
        }

        let sortedMonths = monthUsers.keys.sorted()
        let monthlyPoints: [VisitorsPoint] = sortedMonths.enumerated().map { index, key in
            let count = monthUsers[key]?.count ?? 0
            return VisitorsPoint(x: Double(index), y: Double(count))
        }

        let watchersNew  = subs.reduce(0)   { $0 + $1.dates.count }
        let watchersLeft = unsubs.reduce(0) { $0 + $1.dates.count }

        return EpisodeStatistics(
            visitorsTotal: visitorsTotal,
            dailyPoints: dailyPoints,
            weeklyPoints: weeklyPoints,
            monthlyPoints: monthlyPoints,
            watchersNew: watchersNew,
            watchersLeft: watchersLeft,
            viewsByUser: viewsByUser
        )
    }
}
