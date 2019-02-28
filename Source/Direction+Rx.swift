//
//  Direction+Rx.swift
//  FlowDirection
//
//  Created by pavel.grechikhin on 28.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import RxSwift

public extension Reactive where Base: Direction {
    var willNavigate: Observable<Flow> {
        return self.base.broadcaster.willNavigate.asObservable()
    }
    
    var didNavigate: Observable<Flow> {
        return self.base.broadcaster.didNavigate.asObservable()
    }
}
