# FlowDirection

<p align="center">
  <img alt="Platform" src="https://img.shields.io/badge/platform-iOS-orange.svg">
  <img alt="Swift" src="https://img.shields.io/badge/Swift-4.2-orange.svg">
  <img alt="License" src="https://img.shields.io/badge/LICENSE-MIT-blue.svg">
  <img alt="Version" src="https://img.shields.io/badge/Version-0.0.3-blue.svg">
</p>

#### Implementation pattern coordinator with RxSwift

[Documentation](docs/index.html)

#### Setup

```swift
let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator: Coordiator<ViewControllerType>?
    let bag = DisposeBag()
    let factory: FlowFactory = ViewControllerFactory()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tab = TabBarDirection<ViewControllerType>(flows: [ViewControllerType.tabOne, ViewControllerType.tabTwo])
        let nav = UINavigationController(rootViewController: tab)
        nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav.navigationBar.shadowImage = UIImage()
        
        coordinator = Coordiator<ViewControllerType>(navigationController: nav, tabBarController: tab, builder: factory)
        let dm = DeniedMiddleware()
        coordinator?.registerMiddleware(middleware: dm)
        coordinator?.rx.willNavigate.subscribe({ (event) in
            print("flow -> \(String(describing: event.element!)) will navigate")
        }).disposed(by: bag)
        
        window?.backgroundColor = UIColor.white
        window?.rootViewController = nav
        
        window?.makeKeyAndVisible()
        return true
    }

```

#### Middleware

Middleware is a protocol `CoordinatorMiddleware` you can use two method, simple method with name `process`
```swift
func process(coordinator: Direction, flow: Flow)
``` 
intended for implementations some actions in special case. 

Second method is `resolving`
```swift
func resolving(coordinator: Direction, flow: Flow, resolved: (Resolved) -> Void)
```
used for implements `denied` or `resolve` actions in special case and you can use special case with change your flow.
##### Example

```swift
class DeniedMiddleware: CoordinatorMiddleware {
    func resolving(coordinator: Direction, flow: Flow, resolved: (Resolved) -> Void) {
        guard let flow = flow as? ViewControllerType else {
            return
        }
        
        switch flow {
        case .tabOne:
            resolved(.denied)
        case .tabTwo:
            resolved(.deniedWithAction(action: .present(to: ViewControllerType.first)))
        default:
            resolved(.denied)
        }
    }
}
```
