//
//  EpisodeUserDTO.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

import Foundation

public struct EpisodeUsersDTO: Decodable {
    public let users: [EpisodeUserDTO]
}

public struct EpisodeUserDTO: Decodable {
    public let id: Int
    public let sex: String
    public let username: String
    public let isOnline: Bool
    public let age: Int
    public let files: [EpisodeUserFileDTO]
}

public struct EpisodeUserFileDTO: Decodable {
    public let id: Int
    public let url: String
    public let type: String
}

extension EpisodeUserDTO {
    func toDomain() -> EpisodeUser {
        let avatarUrlString = files.first(where: { $0.type == "avatar" })?.url
        let avatarUrl = avatarUrlString.flatMap { URL(string: $0) }

        return EpisodeUser(
            id: id,
            name: username,
            age: age,
            avatarUrl: avatarUrl,
            sex: sex,
            isOnline: isOnline
        )
    }
}
