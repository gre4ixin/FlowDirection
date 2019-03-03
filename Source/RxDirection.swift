//
//  RxDirection.swift
//  FlowDirection
//
//  Created by pavel.grechikhin on 01.03.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import RxSwift
import RxCocoa

public enum DirectionRoute {
    case push(flow: Flow, animated: Bool, hideTab: Bool)
    case present(flow: Flow, animated: Bool)
    case pop(animated: Bool)
    case toRoot(animated: Bool)
    case presentOnMain(flow: Flow, animated: Bool)
    case dismiss(animated: Bool)
    case none
}

public protocol RxDirection: class {
    var router: PublishRelay<(DirectionRoute, [RxCoordinatorMiddleware]?)> { get }
}
