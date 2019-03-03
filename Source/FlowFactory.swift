//
//  Builder.swift
//  FlowDirection
//
//  Created by Pavel Grechikhin on 27/02/2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation

public protocol FlowFactory {
    /// method will called for create your module
    ///
    /// - Parameter flow: module type
    /// - Returns: view controller
    func makeViewController(with flow: Flow) -> UIViewController
}
