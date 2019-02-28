//
//  UIViewController+Extension.swift
//  FlowDirection
//
//  Created by pavel.grechikhin on 27.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import UIKit

/// Protocol for injecting Coordinator to modules
public protocol Injecting: class {
    var coordinator: Direction? { get set }
}

/// Subclass from UIViewController with coordinator
open class FlowViewController: UIViewController, Injecting {
    /// weak reference to coordinator
    weak public var coordinator: Direction?
}
