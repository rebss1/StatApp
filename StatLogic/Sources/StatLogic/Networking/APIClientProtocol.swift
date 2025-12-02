//
//  APIClientProtocol.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

import RxSwift

public protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) -> Single<T>
}
