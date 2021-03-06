//
//  RxCoordinator.swift
//  FlowDirection
//
//  Created by pavel.grechikhin on 01.03.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import RxCocoa
import RxSwift

public class RxCoordinator: NSObject, RxDirection {
    
    public var topViewController: UIViewController? {
        return navigationControllers[tabBarController.selectedIndex].topViewController
    }
    
    private let navigationController: UINavigationController
    private let tabBarController: RxTabBarController
    private let factory: FlowFactory
    private var bag = DisposeBag()
    public var willNavigate: PublishSubject<(DirectionRoute, Flow?)> = PublishSubject<(DirectionRoute, Flow?)>()
    public var didNavigate: PublishSubject<(DirectionRoute, Flow?)> = PublishSubject<(DirectionRoute, Flow?)>()
    
    /// array of navigation controllers
    private var navigationControllers: [UINavigationController] {
        return tabBarController.viewControllers as? [UINavigationController] ?? []
    }
    
    public var router: PublishRelay<(DirectionRoute, [RxCoordinatorMiddleware]?)> = PublishRelay<(DirectionRoute, [RxCoordinatorMiddleware]?)>()
    
    public init(navigationController: UINavigationController, tabBarController: RxTabBarController, factory: FlowFactory) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
        self.factory = factory
        super.init()
        self.tabBarController.viewControllers?.forEach({ (controller) in
            injectingSelf(controller)
        })
        bind()
    }
    
    public func pushOn(viewFlow: Flow, animated: Bool, hidesTabBar: Bool) {
        let viewController = factory.makeViewController(with: viewFlow)
        if let vc = viewController as? RxFlowController {
            vc.flow = viewFlow
            vc.rxcoordinator = self
        }
        viewController.hidesBottomBarWhenPushed = hidesTabBar
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    public func present(_ viewFlow: Flow, animated: Bool) {
        let viewController = factory.makeViewController(with: viewFlow)
        if let inj = viewController as? RxFlowController {
            inj.rxcoordinator = self
            inj.flow = viewFlow
        }
        navigationControllers[tabBarController.selectedIndex].present(viewController,
                                                                      animated: animated,
                                                                      completion: nil)
    }
    
    public func dismiss(_ animated: Bool) {
        self.navigationControllers[self.tabBarController.selectedIndex]
            .dismiss(animated: animated, completion: nil)
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
    
    public func presentOnMainNavigationController(_ viewFlow: Flow, animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let unwrapSelf = self else {
                return
            }
            let vc = unwrapSelf.factory.makeViewController(with: viewFlow)
            let viewController = unwrapSelf.injection(flow: viewFlow, viewController: vc)
            unwrapSelf.navigationController.pushViewController(viewController, animated: animated)
        }
    }
    
    public func showTab(flow: Flow) {
        if let index = flow.index { showTab(index: index) }
    }
    
    public func showTab(index: Int) {
        tabBarController.selectedIndex = index
        navigationControllers[tabBarController.selectedIndex].popToRootViewController(animated: false)
    }
    
    public func toRootViewController(_ animated: Bool) {
        showTab(index: tabBarController.selectedIndex)
        navigationController.popToRootViewController(animated: animated)
    }
    
    /// execute transition
    ///
    /// - Parameter route: <#route description#>
    private func transition(route: DirectionRoute) {
        switch route {
        case .pop(animated: let animated):
            willNavigate.onNext((route, nil))
            popNavigation(animated: animated)
            if let vc = topViewController as? RxFlowViewController {
                didNavigate.onNext((route, vc.flow))
            } else {
                didNavigate.onNext((route, nil))
            }
        case .toRoot(animated: let animated):
            toRootViewController(animated)
        case .present(flow: let flow, animated: let animated):
            willNavigate.onNext((route, flow))
            _ = present(flow, animated: animated)
            didNavigate.onNext((route, flow))
        case .push(flow: let flow, animated: let animated, hideTab: let hideTabBar):
            willNavigate.onNext((route, flow))
            _ = pushOn(viewFlow: flow, animated: animated, hidesTabBar: hideTabBar)
            didNavigate.onNext((route, flow))
        case .presentOnMain(flow: let flow, animated: let animated):
            willNavigate.onNext((route, flow))
            presentOnMainNavigationController(flow, animated: animated)
            didNavigate.onNext((route, flow))
        case .dismiss(animated: let animated):
            willNavigate.onNext((route, nil))
            dismiss(animated)
            didNavigate.onNext((route, nil))
        case .none:
            break
        }
    }
    
    /// injection flow and coordinator to view controller
    ///
    /// - Parameters:
    ///   - flow: <#flow description#>
    ///   - viewController: <#viewController description#>
    /// - Returns: <#return value description#>
    private func injection(flow: Flow, viewController: UIViewController) -> UIViewController {
        if let vc = viewController as? RxFlowController {
            vc.flow = flow
            vc.rxcoordinator = self
        }
        return viewController
    }
    
}

extension RxCoordinator {
    /// subscribing to route subject
    private func bind() {
        router
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] routerEvent in
                guard let `self` = self else { return }
                var event = routerEvent.0
                if let middlewares = routerEvent.1 {
                    for middleware in middlewares {
                        event = middleware.perfom(event)
                    }
                }
                self.transition(route: event)
            },
                       onError: nil,
                       onCompleted: nil,
                       onDisposed: nil)
            .disposed(by: bag)
    }
}

public extension Reactive where Base: RxCoordinator {
    
    /// binder for route
    var route: Binder<(DirectionRoute, [RxCoordinatorMiddleware]?)> {
        return Binder(self.base) { coordinator, flow in
            coordinator.router.accept(flow)
        }
    }
    
    /// will navigate observable
    var willNavigate: Observable<(DirectionRoute, Flow?)> {
        return self.base.willNavigate.asObservable()
    }
    /// did navigate observable
    var didNavigate: Observable<(DirectionRoute, Flow?)> {
        return self.base.didNavigate.asObservable()
    }
    
}

extension RxCoordinator {
    /// Injecting coordinator to module
    ///
    /// - Parameter controller: UIViewController
    private func injectingSelf(_ controller: UIViewController) {
        if let nav = controller as? UINavigationController {
            if let _inj = nav.viewControllers.first as? RxFlowController {
                _inj.rxcoordinator = self
            }
        } else {
            if let _inj = controller as? RxFlowController {
                _inj.rxcoordinator = self
            }
        }
    }
}
