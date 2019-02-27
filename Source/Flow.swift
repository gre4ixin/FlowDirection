//
//  Flow.swift
//  FlowDirection
//
//  Created by pavel.grechikhin on 27.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation


/// Flow protocol, you must create an enum type and description all your modules
public protocol Flow {
    var flow: UIViewController? { get }
    var index: Int? { get }
}
