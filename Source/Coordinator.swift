//
//  Coordinator.swift
//  FlowDirection
//
//  Created by Pavel Grechikhin on 26/02/2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class Coordiator<Flows: Flow, TabFlows: TabFlow>: NSObject, Direction {

    public typealias FlowType = Flows
    public typealias TabFlowType = TabFlows
    
    public var topViewController: UIViewController? {
        return navigationControllers[tabBarController.selectedIndex].topViewController
    }
    
    public var broadcaster: Broadcaster = Broadcaster()
    
    private let navigationController: UINavigationController
    private let tabBarController: UITabBarController
    private let builder: Builder
    private(set) var middleWares: [CoordinatorMiddleware] = []
    private var currentFlow: FlowType?
    private var currentTabFlow: TabFlowType?
    
    private var navigationControllers: [UINavigationController] {
        return tabBarController.viewControllers as? [UINavigationController] ?? []
    }
    
    init(navigationController: UINavigationController, tabBarController: UITabBarController, builder: Builder) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
        self.builder = builder
    }
    
    public func registerMiddleware(middleware: CoordinatorMiddleware...) {
        middleware.forEach { (middleware) in
            self.middleWares.append(middleware)
        }
    }
    
    public func pushOn<T>(navigationController: UINavigationController, viewFlow: T, animated: Bool, hidesTabBar: Bool) -> Observable<UIViewController> where T : Flow {
        let vc = builder.makeViewController(with: viewFlow)
        return Observable.just(vc)
    }
    
    public func pushOn<T>(viewFlow: T, animated: Bool, hidesTabBar: Bool) -> Observable<UIViewController> where T : Flow {
        let vc = builder.makeViewController(with: viewFlow)
        return Observable.just(vc)
    }
    
    public func present<T>(_ viewFlow: T, animated: Bool) -> Observable<UIViewController> where T : Flow {
        builder.makeViewController(with: viewFlow)
        return Observable.just(UIViewController())
    }
    
    public func dismiss(_ animated: Bool) -> Observable<Void> {
        return Observable<Void>.create({ (obs) -> Disposable in
            obs.onNext(())
            obs.onCompleted()
            return Disposables.create()
        })
    }
    
    public func popViewController(animated: Bool) {
    }
    
    public func popToCallerViewController(_ viewController: UIViewController, animated: Bool) {
    }
    
    public func pullUpOnMain<T>(_ viewFlow: T) -> Observable<UIViewController> where T : Flow {
        let vc = builder.makeViewController(with: viewFlow)
        return Observable.just(vc)
    }
    
    public func presentOnMainNavigationController<T>(_ viewFlow: T, animated: Bool) where T : Flow {
        builder.makeViewController(with: viewFlow)
    }
    
    public func createModule<T>(flow: T) -> UIViewController where T : Flow {
        let vc = builder.makeViewController(with: flow)
        return vc
    }
    
    public func showTab<T>(flow: T) where T : TabFlow {
    }
    
    public func showTab(index: Int) {
    }
    
    public func toRootViewController(_ animated: Bool) {
    }
    
    public func animationPush(flow: Flow) {
        
    }
    
}

extension Coordiator {
    
}

