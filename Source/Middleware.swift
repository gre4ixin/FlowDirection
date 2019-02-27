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
    
    func resolving(coordinator: Direction, flow: Flow, resolved: (Resolved) -> Void)
}

public extension CoordinatorMiddleware {
    
    public func process(coordinator: Direction, flow: Flow) {}
    public func resolving(coordinator: Direction, flow: Flow, resolved: (Resolved) -> Void) { resolved(.resolve) }
}
