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
    private let builder: FlowFactory
    private(set) var middleWares: [CoordinatorMiddleware] = []
    private var currentFlow: FlowType?
    private var bag = DisposeBag()
    
    /// array of navigation controllers
    private var navigationControllers: [UINavigationController] {
        return tabBarController.viewControllers as? [UINavigationController] ?? []
    }
    
    public init(navigationController: UINavigationController, tabBarController: TabBarDirection<Flows>, builder: FlowFactory) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
        self.builder = builder
        
        super.init()
        
        self.tabBarController.viewControllers?.forEach({ (controller) in
            injectingSelf(controller)
        })
        
        bind()
    }
    
    public func registerMiddleware(middleware: CoordinatorMiddleware...) {
        middleware.forEach { (middleware) in
            self.middleWares.append(middleware)
        }
    }
    
    public func pushOn<T>(viewFlow: T, animated: Bool, hidesTabBar: Bool) -> Observable<UIViewController> where T : Flow {
        broadcaster.willNavigate.accept(viewFlow)
        let viewController = builder.makeViewController(with: viewFlow)
        if let vc = viewController as? Injecting {
            vc.flow = viewFlow
            vc.coordinator = self
        }
        viewController.hidesBottomBarWhenPushed = hidesTabBar
        navigationController.pushViewController(viewController, animated: animated)
        broadcaster.didNavigate.accept(viewFlow)
        return .just(viewController)
    }
    
    public func present<T>(_ viewFlow: T, animated: Bool) -> Observable<UIViewController> where T : Flow {
        broadcaster.willNavigate.accept(viewFlow)
        let viewController = builder.makeViewController(with: viewFlow)
        if let inj = viewController as? Injecting {
            inj.coordinator = self
            inj.flow = viewFlow
        }
        navigationControllers[tabBarController.selectedIndex].present(viewController,
                                                                      animated: animated,
                                                                      completion: nil)
        broadcaster.didNavigate.accept(viewFlow)
        return .just(viewController)
    }
    
    /// Dissmissing view controller
    ///
    /// - Parameter animated: bool value
    /// - Returns: Observable<Void>
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
    
    /// If you have to present controller over the tab bar and other controller you can use this method Example (You want to present registration/authorization controller for user)
    ///
    /// - Parameters:
    ///   - viewFlow: flow to present
    ///   - animated: bool value
    public func presentOnMainNavigationController<T>(_ viewFlow: T, animated: Bool) where T : Flow {
        middleWares.forEach { $0.process(coordinator: self, flow: viewFlow) }
        for m in middleWares {
            var breaking = false
            m.resolving(coordinator: self, flow: viewFlow) { (access) in
                switch access {
                case .resolve:
                    broadcaster.willNavigate.accept(viewFlow)
                    DispatchQueue.main.async { [weak self] in
                        guard let unwrapSelf = self else {
                            return
                        }
                        let vc = unwrapSelf.builder.makeViewController(with: viewFlow)
                        if let _vc = vc as? Injecting {
                            _vc.flow = viewFlow
                            _vc.coordinator = self
                        }
                        unwrapSelf.navigationController.pushViewController(vc, animated: animated)
                        unwrapSelf.broadcaster.didNavigate.accept(viewFlow)
                    }
                case .denied:
                    return
                case .deniedWithAction(action: let action):
                    middlewareActionHandler(action)
                    breaking = true
                    return
                }
            }
            if breaking { break }
        }
    }
    
    public func createModule<T>(flow: T) -> UIViewController where T : Flow {
        let vc = builder.makeViewController(with: flow)
        return vc
    }
    
    /// show tab with flow
    ///
    /// - Parameter flow: Flow
    public func showTab<T>(flow: T) where T : Flow {
        if !middleWares.isEmpty {
            middleWares.forEach { $0.process(coordinator: self, flow: flow) }
            for m in middleWares {
                var breaking: Bool = false
                m.resolving(coordinator: self, flow: flow) { (access) in
                    switch access {
                    case .resolve:
                        broadcaster.willNavigate.accept(flow)
                        if let index = flow.index { tabBarController.selectFlow(index) }
                        broadcaster.didNavigate.accept(flow)
                    case .denied:
                        breaking = true
                    case .deniedWithAction(action: let action):
                        middlewareActionHandler(action)
                        breaking = true
                        return
                    }
                }
                if breaking { break }
            }
        } else {
            if let index = flow.index { tabBarController.selectFlow(index) }
        }
    }
    
    /// show tab with index
    ///
    /// - Parameter index: integer value
    public func showTab(index: Int) {
        tabBarController.previousIndex = tabBarController.selectedIndex
        tabBarController.selectedIndex = index
        navigationControllers[tabBarController.selectedIndex].popToRootViewController(animated: false)
    }
    
    /// analog popToRoot
    ///
    /// - Parameter animated: bool value
    public func toRootViewController(_ animated: Bool) {
        showTab(index: tabBarController.selectedIndex)
        navigationController.popToRootViewController(animated: animated)
    }
    
    private func middlewareActionHandler(_ action: DirectionEvent) {
        switch action {
        case .pop:
            self.popViewController(animated: false)
        case .popRoot:
            self.toRootViewController(false)
        case .present(to: let flow):
            if let _flow = flow as? Flows {
                _ = self.present(_flow, animated: true)
            }
            break
        case .push(let with):
            if let _flow = with as? Flows {
                _ = self.pushOn(viewFlow: _flow, animated: true, hidesTabBar: true)
            }
            break
        case .showTab(let with):
            if let _flow = with as? Flows {
                self.showTab(flow: _flow)
            }
            break
        case .presentOnMain(let with):
            if let _flow = with as? Flows {
                self.presentOnMainNavigationController(_flow, animated: true)
            }
            break
        }
    }
    
}

extension Coordiator {
    /// Injecting coordinator to module
    ///
    /// - Parameter controller: UIViewController
    private func injectingSelf(_ controller: UIViewController) {
        if let nav = controller as? UINavigationController {
            if let _inj = nav.viewControllers.first as? Injecting {
                _inj.coordinator = self
            }
        } else {
            if let _inj = controller as? Injecting {
                _inj.coordinator = self
            }
        }
    }
}

extension Coordiator {
    private func bind() {
        tabBarController.selectedFlow.subscribe { [unowned self] (event) in
            if let flow = event.element {
                self.middleWares.forEach { $0.process(coordinator: self, flow: flow) }
                for m in self.middleWares {
                    var breaking = false
                    m.resolving(coordinator: self, flow: flow, resolved: { (access) in
                        switch access {
                        case .resolve:
                            self.broadcaster.willNavigate.accept(flow)
                        case .denied:
                            breaking = true
                        case .deniedWithAction(action: let action):
                            self.middlewareActionHandler(action)
                            breaking = true
                            return
                        }
                    })
                    if breaking { break }
                }
            }
        }.disposed(by: bag)
    }
}
