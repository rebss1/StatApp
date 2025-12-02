//
//  EpisodeStatisticsManaging.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

import RxSwift
import RealmSwift

public protocol EpisodeStatisticsManaging {
    func loadStatistics(forceRefresh: Bool) -> Single<EpisodeStatistics>
    func loadUsers(forceRefresh: Bool) -> Single<[EpisodeUser]>
}
