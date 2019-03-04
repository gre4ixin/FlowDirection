//
//  ViewControllerFactory.swift
//  obsTesting
//
//  Created by pavel.grechikhin on 27.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Foundation
import FlowDirection

enum ViewControllerType: Flow {
    
    case first
    case second
    
    case tabOne
    case tabTwo
    
    var index: Int? {
        switch self {
        case .tabOne:
            return 0
        case .tabTwo:
            return 1
        default:
            return nil
        }
    }
    
    var flow: UIViewController? {
        switch self {
        case .tabOne:
            return UINavigationController(rootViewController: ViewController())
        case .tabTwo:
            return UINavigationController(rootViewController: SecondViewController())
        default:
            return nil
        }
    }
}

class ViewControllerFactory: FlowFactory {
    func makeViewController(with flow: Flow) -> UIViewController {
        guard let flow = flow as? ViewControllerType else {
            fatalError()
        }
        switch flow {
        case .first:
            return ViewController()
        case .second:
            return SecondViewController()
        default:
            return ViewController()
        }
    }
}
