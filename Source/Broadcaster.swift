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
    /// emits flow type before performing transition
    public let willNavigate = PublishRelay<Flow>()
    /// emits flow after transition
    public let didNavigate = PublishRelay<Flow>()
}

public protocol Broadcast {
    /// emits event willNavigate/didNavigate
    var broadcaster: Broadcaster { get }
}
