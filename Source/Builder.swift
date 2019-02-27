//
//  Builder.swift
//  FlowDirection
//
//  Created by Pavel Grechikhin on 27/02/2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation

protocol Builder {
    @discardableResult
    func makeViewController<T: Flow>(with flow: T) -> UIViewController
}
