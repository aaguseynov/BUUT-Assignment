//
//  DIContainer.swift
//  BUUT-Assignment
//
//  Created by Anar Guseinov on 05/04/2026.
//

import Foundation

public enum Scope {
    /// always new
    case transient
    /// singleton
    case container
    /// Reuses one instance per type while it is still alive elsewhere; uses `ObjectIdentifier` as key (not `NSMapTable` + boxed key).
    case weak
}

private final class WeakInstanceBox {
    weak var object: AnyObject?
    init(_ object: AnyObject) {
        self.object = object
    }
}

public final class DIContainer {
    private struct Registration {
        let scope: Scope
        let factory: (DIContainer) -> Any
    }
    
    private weak var parent: DIContainer?
    private var registrations: [ObjectIdentifier: Registration] = [:]
    private var strongStorage: [ObjectIdentifier: Any] = [:]
    private var weakInstanceByType: [ObjectIdentifier: WeakInstanceBox] = [:]
    
    public init(parent: DIContainer? = nil) {
        self.parent = parent
    }
    
    /// Child container that falls back to the parent for resolution (like Swinject `Assembler(parentAssembler:)`).
    public func makeChild() -> DIContainer {
        DIContainer(parent: self)
    }
    
    public func register<T>(
        _ type: T.Type = T.self,
        scope: Scope = .transient,
        factory: @escaping (DIContainer) -> T
    ) {
        registrations[ObjectIdentifier(type)] = Registration(
            scope: scope,
            factory: { container in
                factory(container)
            }
        )
    }
    
    public func resolve<T>(_ type: T.Type = T.self) -> T {
        let key = ObjectIdentifier(type)
        
        guard let registration = registrations[key] else {
            guard let parent else {
                fatalError("No registration for \(type)")
            }
            
            return parent.resolve(type)
        }
        
        switch registration.scope {
        case .transient:
            return registration.factory(self) as! T
            
        case .container:
            guard let existing = strongStorage[key] as? T else {
                let instance = registration.factory(self) as! T
                strongStorage[key] = instance
                return instance
            }
            
            return existing
        case .weak:
            guard let box = weakInstanceByType[key], let existing = box.object as? T else {
                weakInstanceByType.removeValue(forKey: key)
                let instance = registration.factory(self) as! T
                weakInstanceByType[key] = WeakInstanceBox(instance as AnyObject)
                return instance
            }
            return existing
        }
    }
    
    /// Clears registrations and caches for this container only (not the parent).
    public func removeAll() {
        registrations.removeAll()
        strongStorage.removeAll()
        weakInstanceByType.removeAll()
    }
}
