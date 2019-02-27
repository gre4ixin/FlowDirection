//
//  TabBarCoordinator.swift
//  FlowDirection
//
//  Created by Pavel Grechikhin on 26/02/2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

enum Step: Flow {
    case first
}

enum TabStep: TabFlow {
    case second
}

class A {
    let coordinator = Coordiator<Step, TabStep>(navigationController: UINavigationController(), tabBarController: UITabBarController(), builder: Build())
    
    func a() {
        
    }
}

class Build: Builder {
    func makeViewController<T>(with flow: T) -> UIViewController where T : Flow {
        guard let f = flow as? Step else {
            fatalError()
        }
        switch f {
        case .first:
            return UIViewController()
        }
    }
}
