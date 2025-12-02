//
//  RealmProvider.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

import RealmSwift

public final class RealmProvider {

    private let configuration: Realm.Configuration

    public init(configuration: Realm.Configuration = .defaultConfiguration) {
        self.configuration = configuration
    }

    public func realm() throws -> Realm {
        return try Realm(configuration: configuration)
    }
}
