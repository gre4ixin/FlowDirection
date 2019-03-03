//
//  RxTabBarController.swift
//  FlowDirection
//
//  Created by pavel.grechikhin on 01.03.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import UIKit
import RxSwift

open class RxTabBarController: UITabBarController, UITabBarControllerDelegate {

    public var itemIndexSubject = BehaviorSubject<Int>(value: 0)
    
    public var flowsArray: [Flow] = []
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open var selectedViewController: UIViewController? {
        willSet {
            if let vc = newValue, let index = self.viewControllers?.firstIndex(of:vc) {
                itemIndexSubject.onNext(index)
            }
        }
        didSet {}
    }
    
    public init(flows: [Flow]) {
        flowsArray = flows
        super.init(nibName: nil, bundle: nil)
        setFlow(flows: flows)
        delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension RxTabBarController {
    private func setFlow(flows: [Flow]) {
        self.viewControllers = []
        var tempFlows: [UIViewController] = []
        for flow in flows {
            if let vc = flow.flow {
                if let nav = vc as? UINavigationController {
                    if let navFlow = nav.viewControllers.first as? RxFlowController {
                        navFlow.flow = flow
                    }
                    tempFlows.append(vc)
                } else if let flowVC = vc as? RxFlowController {
                    flowVC.flow = flow
                    tempFlows.append(vc)
                }
            }
        }
        self.viewControllers = tempFlows
    }
}
