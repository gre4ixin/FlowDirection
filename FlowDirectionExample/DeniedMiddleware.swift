//
//  DeniedMiddleware.swift
//  obsTesting
//
//  Created by pavel.grechikhin on 27.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation
import FlowDirection

class DeniedMiddleware: RxCoordinatorMiddleware {
    func perfom(_ route: DirectionRoute) -> DirectionRoute {
        switch route {
        case .push(flow: _, animated: _, hideTab: _):
            return .present(flow: ViewControllerType.second, animated: true)
        default:
            return .push(flow: ViewControllerType.first, animated: true, hideTab: false)
        }
    }
}
