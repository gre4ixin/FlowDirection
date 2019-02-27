//
//  UIViewController+Extension.swift
//  FlowDirection
//
//  Created by pavel.grechikhin on 27.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import UIKit

public protocol Injecting: class {
    var coordinator: Direction? { get set }
}

open class FlowViewController: UIViewController, Injecting {
    weak public var coordinator: Direction?
}
