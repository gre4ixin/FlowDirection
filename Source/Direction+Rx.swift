//
//  Direction+Rx.swift
//  FlowDirection
//
//  Created by pavel.grechikhin on 28.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import RxSwift

// MARK: - add reactive extension for more convenient use events from Broadcaster. now use coordinator.rx.willNavigate/didNavigate instead coordinator.broadcaser.willNavigate/didNavigate
public extension Reactive where Base: Direction {
    /// emit flow before transition performing
    var willNavigate: Observable<Flow> {
        return self.base.broadcaster.willNavigate.asObservable()
    }
    
    /// emit flow after transition performing
    var didNavigate: Observable<Flow> {
        return self.base.broadcaster.didNavigate.asObservable()
    }
}
