# FlowDirection

<p align="center">
  <img alt="Platform" src="https://img.shields.io/badge/platform-iOS-orange.svg">
  <img alt="Swift" src="https://img.shields.io/badge/Swift-4.2-orange.svg">
  <img alt="License" src="https://img.shields.io/badge/LICENSE-MIT-blue.svg">
  <img alt="Version" src="https://img.shields.io/badge/Version-0.0.4-blue.svg">
</p>

#### Implementation pattern coordinator with RxSwift

### 📲 Installation
##### Cocoapods
```
pod 'FlowDirection'
```

```
pod install
```

### 👨🏼‍💻 How to use?

#### In app delegate setup `RxCoordinator` and `RxTabBarController`

```swift
import RxSwift
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
        let nav = UINavigationController(rootViewController: tab)
        coordinator = RxCoordinator(navigationController: nav, tabBarController: tab, builder: factory)
        // optional
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
}
```

#### Create new file `ViewControllerFactory` (you can you other name), my factory look like this 👇🏼

```swift

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

```

##### In ViewController you have to inheritance from `RxFlowViewController`

```swift
import RxSwift
import RxCocoa
import FlowDirection

class ViewController: RxFlowViewController {

  func bind() {}
        button.rx.tap.map { (_) -> (DirectionRoute, [RxCoordinatorMiddleware]?) in
            return (DirectionRoute.present(flow: ViewControllerType.second, animated: true), .none)
        }
            .bind(to: rxcoordinator!.rx.route)
            .disposed(by: bag)
    }
    
}
```

##### And that's all

#### Middleware

##### You can use middleware for processing your navigation command, it's very simple too. Create new file, create class 

```swift
class DeniedMiddleware: RxCoordinatorMiddleware {
    func perfom(_ route: DirectionRoute) -> DirectionRoute {
        switch route {
        case .push(flow: _, animated: _, hideTab: _):
            return .present(flow: ViewControllerType.second, animated: true)
        default:
            return .push(flow: ViewControllerType.first, animated: true, hideTab: false)
        }
    }
}
```

##### Now, you have to add this middleware to DirectionRoute, return to your ViewController and change code in `map` function.

```swift
button.rx.tap.map { (_) -> (DirectionRoute, [RxCoordinatorMiddleware]?) in
    let mid = DeniedMiddleware()
    return (DirectionRoute.present(flow: ViewControllerType.second, animated: true), [mid])
}.bind(to: rxcoordinator!.rx.route)
```