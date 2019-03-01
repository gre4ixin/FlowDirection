//
//  Builder.swift
//  FlowDirection
//
//  Created by Pavel Grechikhin on 27/02/2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation

public protocol FlowFactory {
    @discardableResult
    /// method will called for create your module
    ///
    /// - Parameter flow: module type
    /// - Returns: view controller
    func makeViewController1<T: Flow>(with flow: T) -> UIViewController
    
    func makeViewController(with flow: Flow) -> UIViewController
}
