//
//  AppAssembly.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation
import LightweightNetworking

/// Root-level DI registrations for the app target.
struct AppAssembly: Assembly {
    func assemble(into container: DIContainer) {
        container.register(NetworkClient.self, scope: .container) { _ in
            let configuration = URLSessionConfiguration.default
            // `.default` enables URLCache; offline requests could still return a cached JSON body.
            configuration.urlCache = nil
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            return NetworkClient(configuration: configuration)
        }
    }
}
