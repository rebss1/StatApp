//
//  Endpoint.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

public struct Endpoint {
    public let path: String
    public let method: HTTPMethod

    public init(path: String, method: HTTPMethod = .get) {
        self.path = path
        self.method = method
    }
}
