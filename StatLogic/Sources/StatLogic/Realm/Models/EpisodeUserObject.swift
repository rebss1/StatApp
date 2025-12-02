//
//  EpisodeUserObject.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

import RealmSwift
import Foundation

public final class EpisodeUserObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var episodeId: Int
    @Persisted var name: String
    @Persisted var age: Int?
    @Persisted var avatarUrlString: String?
    @Persisted var sex: String?
    @Persisted var isOnline: Bool
}

extension EpisodeUserObject {
    func toDomain() -> EpisodeUser {
        let url = avatarUrlString.flatMap { URL(string: $0) }

        return EpisodeUser(
            id: id,
            name: name,
            age: age,
            avatarUrl: url,
            sex: sex,
            isOnline: isOnline
        )
    }

    func fill(from dto: EpisodeUserDTO, episodeId: Int) {
        self.id = dto.id
        self.episodeId = episodeId
        self.name = dto.username
        self.age = dto.age
        self.sex = dto.sex
        self.isOnline = dto.isOnline
        self.avatarUrlString = dto.files.first(where: { $0.type == "avatar" })?.url
    }
}
