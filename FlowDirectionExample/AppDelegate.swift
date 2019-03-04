//
//  AppDelegate.swift
//  obsTesting
//
//  Created by pavel.grechikhin on 22.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FlowDirection

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator: RxCoordinator?
    let bag = DisposeBag()
    let factory: FlowFactory = ViewControllerFactory()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tab = RxTabBarController(flows: [ViewControllerType.tabOne, ViewControllerType.tabTwo])
        
        tab.itemIndexSubject.subscribe { (event) in
            
        }.disposed(by: bag)
        let nav = UINavigationController(rootViewController: tab)
        coordinator = RxCoordinator(navigationController: nav, tabBarController: tab, builder: factory)
        
        coordinator?.rx.willNavigate.subscribe(onNext: { (direction) in
            if let flow = direction.1 {
                print("direction -> \(direction.0) flow -> \(flow)")
            } else {
                print("direction -> \(direction.0)")
            }
        }).disposed(by: bag)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }
        
//        let tab = RxTabBarController(flows: [ViewControllerType.tabOne, ViewControllerType.tabTwo])
//        let nav = UINavigationController(rootViewController: tab)
//        nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        nav.navigationBar.shadowImage = UIImage()
//
//        coordinator = RxCoordinator(navigationController: nav, tabBarController: tab, builder: factory)
//
//        coordinator?.rx.willNavigate.subscribe { (event) in
//            print(event)
//        }.disposed(by: bag)
//
//        window?.backgroundColor = UIColor.white
////        window?.rootViewController = nav
//
//        window?.makeKeyAndVisible()
//        return true
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
