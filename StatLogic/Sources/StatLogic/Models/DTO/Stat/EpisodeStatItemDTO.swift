//
//  EpisodeStatItemDTO.swift
//  StatLogic
//
//  Created by Анастасия Журавлева on 03.12.2025.
//

import Foundation

public struct EpisodeStatItemDTO: Codable {
    public let userId: Int?
    public let type: EpisodeStatType
    public let dates: [Int]
}
