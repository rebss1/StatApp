//
//  APIClient.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

import RxSwift
import Foundation

public final class APIClient: APIClientProtocol {

    private let baseURL: URL
    private let session: URLSession

    public init(
        baseURL: URL = URL(string: "http://test-case.rikmasters.ru/api")!,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }

    public func request<T: Decodable>(_ endpoint: Endpoint) -> Single<T> {
        let url = baseURL.appendingPathComponent(endpoint.path)

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        return Single<T>.create { [session] single in
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                guard
                    let httpResponse = response as? HTTPURLResponse,
                    200..<300 ~= httpResponse.statusCode,
                    let data = data
                else {
                    single(.failure(NSError(domain: "APIError", code: -1)))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(T.self, from: data)
                    single(.success(result))
                } catch {
                    single(.failure(error))
                }
            }

            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
