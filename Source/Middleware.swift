//
//  Middleware.swift
//  FlowDirection
//
//  Created by Pavel Grechikhin on 27/02/2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation

/// Middleware detail resolved event
///
/// - push: push view controller with flow
/// - pop: pop view controller
/// - present: present view controller with flow
/// - showTab: select tab with flow
/// - pushOnMain: push on main nav bar
/// - popRoot: pop to root view controller for current navigation bar
public enum DirectionEvent {
    /// push view controller with flow
    case push(with: Flow)
    /// pop view controller
    case pop
    /// present view controller with flow
    case present(to: Flow)
    /// select tab with flow
    case showTab(with: Flow)
    /// presentation on main nav bar
    case presentOnMain(with: Flow)
    /// pop to root view controller for current navigation bar
    case popRoot
}


/// Access resolver/denied
///
/// - denied: denied access to module
/// - resolve: resolve access to module
public enum Resolved {
    /// denied access to module
    case denied
    /// resolve access to module
    case resolve
    
    case deniedWithAction(action: DirectionEvent)
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


public protocol Middleware {
    /// You can register middleware, which will be called before performing the transition
    ///
    /// - Parameter middleware: Middlewares array
    func registerMiddleware(middleware: CoordinatorMiddleware...)
}
