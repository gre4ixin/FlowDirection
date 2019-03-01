//
//  RxCoordinatorMiddleware.swift
//  FlowDirection
//
//  Created by pavel.grechikhin on 01.03.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation

public protocol RxCoordinatorMiddleware {
    func perfom(_ route: DirectionRoute) -> DirectionRoute
}
