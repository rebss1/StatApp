//
//  EpisodesAPI.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

public enum EpisodesAPI {
    public static var statistics: Endpoint {
        Endpoint(path: "episode/statistics/")
    }

    public static var users: Endpoint {
        Endpoint(path: "episode/users/")
    }
}
