//
//  Direction.swift
//  FlowDirection
//
//  Created by pavel.grechikhin on 26.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import RxSwift

/// the Protocol for the description of the coordinator class
public protocol Direction: class {
    
    /// Return top view controller (only get)
    var topViewController: UIViewController? { get }
    /// emits event willNavigate/didNavigate
    var broadcaster: Broadcaster { get }
    
    /// Push view controller method
    ///
    /// - Parameters:
    ///   - navigationController: navigation controller in which embed controller
    ///   - viewFlow: enum
    ///   - animated: bool value
    ///   - hidesTabBar: bool value
    /// - Returns: observable with type UIViewController
    func pushOn<T: Flow>(navigationController: UINavigationController,
                viewFlow: T,
                animated: Bool,
                hidesTabBar: Bool) -> Observable<UIViewController>
    
    /// Push view controller method
    ///
    /// - Parameters:
    ///   - viewFlow: enum
    ///   - animated: bool value
    ///   - hidesTabBar: bool value
    /// - Returns: observable with type UIViewController
    func pushOn<T: Flow>(viewFlow: T,
                animated: Bool,
                hidesTabBar: Bool) -> Observable<UIViewController>
    
    /// Presentation view controller method
    ///
    /// - Parameters:
    ///   - viewFlow: enum
    ///   - animated: bool value
    /// - Returns: Observable with type UIViewController
    func present<T: Flow>(_ viewFlow: T, animated: Bool) -> Observable<UIViewController>
    
    /// Dismiss view controller method
    ///
    /// - Parameter animated: bool value
    /// - Returns: Observable with type Void
    func dismiss(_ animated: Bool) -> Observable<Void>
    
    /// Return to previous view controller
    ///
    /// - Parameter animated: bool value
    func popViewController(animated: Bool)
    
    func popToCallerViewController(_ viewController: UIViewController, animated: Bool)
    
    /// Pull view controller to main screen
    ///
    /// - Parameter viewControllerType:
    /// - Returns: Observable
    func pullUpOnMain<T: Flow>(_ viewFlow: T) -> Observable<UIViewController>
    
    /// Present view controller on main nav controller
    ///
    /// - Parameters:
    ///   - viewControllerType: enum
    ///   - animated: bool value
    func presentOnMainNavigationController<T: Flow>(_ viewFlow: T, animated: Bool)
    
    /// Creating module
    ///
    /// - Parameter type: enum
    /// - Returns: return view controller
    func createModule<T: Flow>(flow: T) -> UIViewController
    
    /// Open tab bar item with type
    ///
    /// - Parameter type: type of tab bar item
    func showTab<T: DirectionFlow>(flow: T)
    
    /// Open tab bar item with index
    ///
    /// - Parameter index: Integer value
    func showTab(index: Int)
    
    /// Pop to root view controller
    ///
    /// - Parameter animated: bool value
    func toRootViewController(_ animated: Bool)
    
    /// You can register middleware, which will be called before performing the transition
    ///
    /// - Parameter middleware: Middlewares array
    func registerMiddleware(middleware: CoordinatorMiddleware...)
    
}
