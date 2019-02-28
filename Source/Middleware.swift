//
//  Middleware.swift
//  FlowDirection
//
//  Created by Pavel Grechikhin on 27/02/2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation

public enum Resolved {
    case denied
    case resolve
}

public protocol CoordinatorMiddleware {
    /// Perform before transition
    ///
    /// - Parameters:
    ///   - coordinator: direction obj
    ///   - flow: type transition
    func process(coordinator: Direction, flow: Flow)
    
    /// Resolve or denied performing transition
    ///
    /// - Parameters:
    ///   - coordinator: direction object
    ///   - flow: flow type transition
    ///   - resolved: closure with enum entry
    func resolving(coordinator: Direction, flow: Flow, resolved: (Resolved) -> Void)
}

// MARK: - Default implementation
public extension CoordinatorMiddleware {
    
    /// Perform before transition (default implmentation)
    ///
    /// - Parameters:
    ///   - coordinator: direction object
    ///   - flow: flow type transition
    public func process(coordinator: Direction, flow: Flow) {}
    
    /// Resolve or denied performing transition (default implementation)
    ///
    /// - Parameters:
    ///   - coordinator: direction object
    ///   - flow: flow type transition
    ///   - resolved: closure with enum entry
    public func resolving(coordinator: Direction, flow: Flow, resolved: (Resolved) -> Void) { resolved(.resolve) }
}
