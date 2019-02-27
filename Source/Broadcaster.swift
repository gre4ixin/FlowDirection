//
//  Broadcaster.swift
//  FlowDirection
//
//  Created by Pavel Grechikhin on 27/02/2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import RxSwift
import RxCocoa

public class Broadcaster: NSObject {
    let willNavigate = PublishRelay<Flow>()
    let didNavigate = PublishRelay<Flow>()
}
