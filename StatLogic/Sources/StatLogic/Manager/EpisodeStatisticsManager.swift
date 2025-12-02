//
//  EpisodeStatisticsManager.swift
//  StatLogic
//
//  Created by Илья Лощилов on 02.12.2025.
//

import RxSwift
import RealmSwift
import Foundation

public final class EpisodeStatisticsManager: EpisodeStatisticsManaging {
    
    private enum CacheError: Error {
        case empty
    }
    
    private let apiClient: APIClientProtocol
    private let realmProvider: RealmProvider
    
    public init(
        apiClient: APIClientProtocol,
        realmProvider: RealmProvider = RealmProvider()
    ) {
        self.apiClient = apiClient
        self.realmProvider = realmProvider
    }
    
    public func loadStatistics(forceRefresh: Bool) -> Single<EpisodeStatistics> {
        if forceRefresh {
            return fetchAndCacheStatistics()
        } else {
            return loadCachedStatistics()
                .catch { [weak self] error in
                    guard let self = self else { return .error(error) }
                    
                    if case CacheError.empty = error {
                        return self.fetchAndCacheStatistics()
                    } else {
                        return .error(error)
                    }
                }
        }
    }
    
    public func loadUsers(forceRefresh: Bool) -> Single<[EpisodeUser]> {
        if forceRefresh {
            return fetchAndCacheUsers()
        } else {
            return loadCachedUsers()
                .catch { [weak self] error in
                    guard let self = self else { return .error(error) }

                    if case CacheError.empty = error {
                        return self.fetchAndCacheUsers()
                    } else {
                        return .error(error)
                    }
                }
        }
    }
    
    private func loadCachedStatistics() -> Single<EpisodeStatistics> {
        return Single.create { [realmProvider] single in
            do {
                let realm = try realmProvider.realm()
                if let obj = realm.object(
                    ofType: EpisodeStatisticsObject.self,
                    forPrimaryKey: 0
                ) {
                    let decoder = JSONDecoder()
                    let dto = try decoder.decode(EpisodeStatisticsDTO.self, from: obj.jsonData)
                    let model = dto.toDomain()
                    single(.success(model))
                } else {
                    single(.failure(CacheError.empty))
                }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    private func fetchAndCacheStatistics() -> Single<EpisodeStatistics> {
        let request: Single<EpisodeStatisticsDTO> = apiClient.request(EpisodesAPI.statistics)
        
        return request.flatMap { [realmProvider] dto -> Single<EpisodeStatistics> in
            do {
                let data = try JSONEncoder().encode(dto)
                let realm = try realmProvider.realm()
                try realm.write {
                    let obj = EpisodeStatisticsObject()
                    obj.episodeId = 0
                    obj.jsonData = data
                    obj.updatedAt = Date()
                    realm.add(obj, update: .modified)
                }
                
                return .just(dto.toDomain())
            } catch {
                return .error(error)
            }
        }
    }
    
    private func loadCachedUsers() -> Single<[EpisodeUser]> {
        return Single.create { [realmProvider] single in
            do {
                let realm = try realmProvider.realm()
                let objects = realm.objects(EpisodeUserObject.self)
                    .filter("episodeId == %@", 0)

                guard !objects.isEmpty else {
                    single(.failure(CacheError.empty))
                    return Disposables.create()
                }

                let users = objects.map { $0.toDomain() }
                single(.success(Array(users)))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    private func fetchAndCacheUsers() -> Single<[EpisodeUser]> {
        let request: Single<EpisodeUsersDTO> = apiClient.request(EpisodesAPI.users)

        return request.flatMap { [realmProvider] dto -> Single<[EpisodeUser]> in
            do {
                let realm = try realmProvider.realm()
                let users = dto.users.map { $0.toDomain() }
                try realm.write {
                    let oldObjects = realm.objects(EpisodeUserObject.self)
                        .filter("episodeId == %@", 0)
                    realm.delete(oldObjects)

                    for userDTO in dto.users {
                        let obj = EpisodeUserObject()
                        obj.fill(from: userDTO, episodeId: 0)
                        realm.add(obj, update: .modified)
                    }
                }

                return .just(users)
            } catch {
                return .error(error)
            }
        }
    }
}
