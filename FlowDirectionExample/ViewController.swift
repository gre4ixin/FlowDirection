//
//  ViewController.swift
//  obsTesting
//
//  Created by pavel.grechikhin on 22.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FlowDirection

class ViewController: RxFlowViewController {

    let label = UILabel()
    let button = UIButton()
    let bag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        setup()
    }
    
    func setup() {
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        label.text = "ТЕСТ"
        
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(50)
        }
        button.setTitle("Переход", for: .normal)
        button.setTitleColor(UIColor.purple, for: .normal)
        button.rx.tap.map { (_) -> (DirectionRoute, [RxCoordinatorMiddleware]?) in
            let mid = DeniedMiddleware()
//            return (DirectionRoute.present(flow: ViewControllerType.second, animated: true), .none)
            return (DirectionRoute.present(flow: ViewControllerType.second, animated: true), [mid])
        }
            .bind(to: rxcoordinator!.rx.route)
            .disposed(by: bag)
    }
    
}
