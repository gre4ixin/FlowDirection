//
//  SecondViewController.swift
//  obsTesting
//
//  Created by pavel.grechikhin on 27.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import UIKit
import FlowDirection
import RxSwift
import RxCocoa

class SecondViewController: RxFlowViewController {

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
        view.backgroundColor = UIColor.gray
        setup()
    }
    
    func setup() {
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        label.text = "ВТОРОЙ ЭКРАН"
        
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(50)
        }
        button.setTitle("Закрыть", for: .normal)
        button.setTitleColor(UIColor.purple, for: .normal)
        button.rx.tap.map { (_) -> (DirectionRoute, [RxCoordinatorMiddleware]?) in
//            let mid = DeniedMiddleware()
            return (DirectionRoute.dismiss(animated: true), .none)
//            return (DirectionRoute.dismiss(animated: true), [mid])
            }
            .bind(to: rxcoordinator!.rx.route)
            .disposed(by: bag)
    }

}
