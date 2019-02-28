//
//  TabBarDirection.swift
//  FlowDirection
//
//  Created by pavel.grechikhin on 27.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import UIKit
import RxSwift

open class TabBarDirection<Elements: Flow>: UITabBarController, UITabBarControllerDelegate {
    
    public typealias TabBarFlow = Elements
    
    private var itemIndexSubject = BehaviorSubject<Int>(value: 0)
    private var flowSubject = PublishSubject<Flow>()
    
    public var selectedItemIndex: Observable<Int> {
        return itemIndexSubject.asObservable()
    }
    
    public var selectedFlow: Observable<Flow> {
        return flowSubject.asObservable()
    }
    
    internal var previousIndex: Int = 0
    
    /// set view your flows
    public var flowsArray: [TabBarFlow] = []
    
    override open var selectedViewController: UIViewController? {
        willSet {
            if let vc = newValue, let index = self.viewControllers?.firstIndex(of:vc) {
                itemIndexSubject.onNext(index)
                if let flowVC = newValue as? Injecting, let flow = flowVC.flow {
                    flowSubject.onNext(flow)
                }
            }
        }
        didSet {}
    }
    
    public init(flows: [Elements]) {
        flowsArray = flows
        super.init(nibName: nil, bundle: nil)
        setFlow(flows: flows)
        delegate = self
    }
    
    public init(navigationFlows: [Elements]) {
        super.init(nibName: nil, bundle: nil)
        delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open func selectFlow(_ flow: Int) {
        self.selectedIndex = flow
    }
    
    open func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let index = tabBarController.viewControllers?.firstIndex(of: toVC) {
            itemIndexSubject.onNext(index)
        }
        return nil
    }
    
    open func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
    
    open func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            itemIndexSubject.onNext(index)
        }
        return true
    }

}

extension TabBarDirection {
    private func setFlow(flows: [TabBarFlow]) {
        self.viewControllers = []
        var tempFlows: [UIViewController] = []
        for flow in flows {
            if let vc = flow.flow {
                if let nav = vc as? UINavigationController {
                    if let navFlow = nav.viewControllers.first as? FlowViewController {
                        navFlow.flow = flow
                    }
                    tempFlows.append(vc)
                } else if let flowVC = vc as? FlowViewController {
                    flowVC.flow = flow
                    tempFlows.append(vc)
                }
            }
        }
        self.viewControllers = tempFlows
    }
}
