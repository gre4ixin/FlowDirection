//
//  Middleware.swift
//  FlowDirection
//
//  Created by Pavel Grechikhin on 27/02/2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation

public protocol CoordinatorMiddleware {
    /// Perform before transition
    ///
    /// - Parameters:
    ///   - coordinator: direction obj
    ///   - flow: type transition
    func process(coordinator: Direction, flow: Flow)
}

public extension CoordinatorMiddleware {
    
    public func process(coordinator: Direction, flow: Flow) {}
    
}
