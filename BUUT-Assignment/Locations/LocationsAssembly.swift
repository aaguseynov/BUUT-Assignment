//
//  LocationsAssembly.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation
import LightweightNetworking

/// DI registrations for the Locations feature (Dependency Inversion: resolve protocols).
struct LocationsAssembly: Assembly {
    func assemble(into container: DIContainer) {
        container.register(LocationMapping.self, scope: .weak) { _ in
            LocationMapper()
        }

        container.register(LocationsRepositoryProtocol.self, scope: .weak) { c in
            LocationsRepository(
                networkService: c.resolve(NetworkClient.self),
                mapper: c.resolve(LocationMapping.self)
            )
        }

        container.register(FetchLocationsUseCaseProtocol.self, scope: .weak) { c in
            FetchLocationsUseCase(repository: c.resolve(LocationsRepositoryProtocol.self))
        }

        container.register(LocationsListStringsProviding.self, scope: .weak) { _ in
            DefaultLocationsListStrings()
        }

        container.register(LocationsListItemMapping.self, scope: .weak) { _ in
            LocationsListItemMapper()
        }
    }
}
