# FlowDirection

### Implementation pattern coordinator with RxSwift

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