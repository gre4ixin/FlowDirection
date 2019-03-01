//
//  RxFlowViewController.swift
//  FlowDirection
//
//  Created by pavel.grechikhin on 01.03.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

public protocol RxFlowController: class {
    var rxcoordinator: RxCoordinator? { get set }
    var listener: PublishRelay<(DirectionRoute, [RxCoordinatorMiddleware])>? { get set }
    var flow: Flow? { get set }
}

open class RxFlowViewController: UIViewController, RxFlowController {
    weak public var rxcoordinator: RxCoordinator?
    weak public var listener: PublishRelay<(DirectionRoute, [RxCoordinatorMiddleware])>?
    public var flow: Flow?
}
