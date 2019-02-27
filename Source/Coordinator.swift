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

/// Implementation coordinator pattern and Direction protocol
public class Coordiator<Flows: Flow>: NSObject, Direction {

    /// generic for users flow
    public typealias FlowType = Flows
    
    /// current view controller or top view controller in current navigation controller
    public var topViewController: UIViewController? {
        return navigationControllers[tabBarController.selectedIndex].topViewController
    }
    
    /// broadcaster emiter
    public var broadcaster: Broadcaster = Broadcaster()
    
    private let navigationController: UINavigationController
    private let tabBarController: TabBarDirection<Flows>
    private let builder: Builder
    private(set) var middleWares: [CoordinatorMiddleware] = []
    private var currentFlow: FlowType?
    
    /// array of navigation controllers
    private var navigationControllers: [UINavigationController] {
        return tabBarController.viewControllers as? [UINavigationController] ?? []
    }
    
    init(navigationController: UINavigationController, tabBarController: TabBarDirection<Flows>, builder: Builder) {
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
        let viewController = builder.makeViewController(with: viewFlow)
        viewController.hidesBottomBarWhenPushed = hidesTabBar
        navigationController.pushViewController(viewController, animated: animated)
        return .just(viewController)
    }
    
    public func pushOn<T>(viewFlow: T, animated: Bool, hidesTabBar: Bool) -> Observable<UIViewController> where T : Flow {
        let viewController = builder.makeViewController(with: viewFlow)
        viewController.hidesBottomBarWhenPushed = hidesTabBar
        navigationController.pushViewController(viewController, animated: animated)
        return .just(viewController)
    }
    
    public func present<T>(_ viewFlow: T, animated: Bool) -> Observable<UIViewController> where T : Flow {
        let viewController = builder.makeViewController(with: viewFlow)
        navigationControllers[tabBarController.selectedIndex].present(viewController,
                                                                      animated: animated,
                                                                      completion: nil)
        return .just(viewController)
    }
    
    public func dismiss(_ animated: Bool) -> Observable<Void> {
        let completionObservable: Observable<Void> = .create { [unowned self] observer in
            self.navigationControllers[self.tabBarController.selectedIndex]
                .dismiss(animated: animated, completion: {
                    observer.onNext(())
                    observer.onCompleted()
                })
            return Disposables.create()
        }
        
        return completionObservable
    }
    
    public func popViewController(animated: Bool) {
        navigationControllers[tabBarController.selectedIndex].popViewController(animated: animated)
    }
    
    public func popNavigation(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    public func popToCallerViewController(_ viewController: UIViewController, animated: Bool) {
        let navigationController = navigationControllers[tabBarController.selectedIndex]
        let viewControllers = navigationController.viewControllers
        guard let index = viewControllers.lastIndex(where: { $0 === viewController }) else { return }
        let popToIndex = max(index - 1, 0)
        navigationController.popToViewController(viewControllers[popToIndex], animated: animated)
    }
    
    public func presentOnMainNavigationController<T>(_ viewFlow: T, animated: Bool) where T : Flow {
        middleWares.forEach { $0.process(coordinator: self, flow: viewFlow) }
        middleWares.forEach { $0.resolving(coordinator: self, flow: viewFlow, resolved: { (access) in
            switch access {
            case .resolve:
                builder.makeViewController(with: viewFlow)
            case .denied:
                return
            }
        })}
    }
    
    public func createModule<T>(flow: T) -> UIViewController where T : Flow {
        let vc = builder.makeViewController(with: flow)
        return vc
    }
    
    public func showTab<T>(flow: T) where T : Flow {
        middleWares.forEach { $0.process(coordinator: self, flow: flow) }
        middleWares.forEach { $0.resolving(coordinator: self, flow: flow, resolved: { (access) in
            switch access {
            case .resolve:
                if let index = flow.index { tabBarController.selectFlow(index) }
            case .denied:
                return
            }
        }) }
    }
    
    public func showTab(index: Int) {
        tabBarController.selectedIndex = index
        navigationControllers[tabBarController.selectedIndex].popToRootViewController(animated: false)
    }
    
    public func toRootViewController(_ animated: Bool) {
        showTab(index: tabBarController.selectedIndex)
        navigationController.popToRootViewController(animated: animated)
    }
    
}
