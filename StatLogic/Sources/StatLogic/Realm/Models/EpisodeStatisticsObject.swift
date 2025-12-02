//
//  EpisodeStatisticsObject.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

import RealmSwift
import Foundation

public final class EpisodeStatisticsObject: Object {
    @Persisted(primaryKey: true) var episodeId: Int
    @Persisted var jsonData: Data
    @Persisted var updatedAt: Date
}
