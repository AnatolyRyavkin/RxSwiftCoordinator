//
//  AppCoordinatorObserving.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 29.04.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class AppCoordinatorObser: CoordinatorProtocol {

    var arrayCoordinators: Array<Any>?

    //MARK: Singleton begin

    private static var instance: AppCoordinatorObser?

    public static var Shared: AppCoordinatorObser{
        if AppCoordinatorObser.instance == nil{
            #if DEBUG
                print("AppCoordinatorObser is empty, execute SharedInit !!!")
                fatalError()
            #else
                _ = AppCoordinatorObser.SharedInit(nc: UINavigationController(), sourseViewController: UIViewController())
            #endif
        }
        return AppCoordinatorObser.instance!
    }

    public static func SharedInit(nc: UINavigationController, sourseViewController: UIViewController) -> AppCoordinatorObser{
        if AppCoordinatorObser.instance == nil{
            AppCoordinatorObser.instance = AppCoordinatorObser.init(nc: nc, sourseViewController: sourseViewController)
        }
        return AppCoordinatorObser.instance!
    }

    //MARK: Singleton end

    var coordinator1: Coordinator1!
    var coordinator2: Coordinator2!
    private let disposeBag = DisposeBag()
    var nc: UINavigationController
    var sourseViewController: UIViewController

    private init(nc: UINavigationController, sourseViewController: UIViewController){
        self.nc = nc
        self.sourseViewController = sourseViewController
        print("init CoordinatorApp")
    }

    deinit {
        print("deinit CoordinatorApp")
    }

    func start(from viewController: UIViewController) -> Observable<Void> {

        viewController.rx.viewDidAppear.subscribe(onNext:  {  _ in
            if arc4random_uniform(10) >= 10 {
                self.coordinator1 = Coordinator1.SharedInit(nc: self.nc)
                if self.arrayCoordinators == nil{
                    self.arrayCoordinators = [Any]()
                }
                self.arrayCoordinators!.append(self.coordinator1 as Any)
                self.coordinate(to: self.coordinator1, from: viewController).subscribe{ _ in}.disposed(by: self.disposeBag)
                return
            }else{
                self.coordinator2 = Coordinator2.SharedInit(nc: self.nc)
                if self.arrayCoordinators == nil{
                    self.arrayCoordinators = [Any]()
                }
                self.arrayCoordinators!.append(self.coordinator2 as Any)
                self.coordinate(to: self.coordinator2, from: viewController).subscribe{ _ in}.disposed(by: self.disposeBag)
                return
            }
        }).disposed(by: disposeBag)
        return  Observable<Void>.empty()
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from viewController: UIViewController) -> Observable<Void> where Coordinator : CoordinatorProtocol {
        return coordinator.start(from: viewController) as! Observable<Void>
    }

}
