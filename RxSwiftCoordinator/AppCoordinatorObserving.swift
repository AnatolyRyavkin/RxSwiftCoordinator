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

 protocol CoordinatorProtocol {
//    associatedtype ElementForObservableStart
//    associatedtype ElementForObservableCoordinate
//    typealias ObservableStartType = Observable<ElementForObservableStart>
//    typealias ObservableCoordinateType = Observable<ElementForObservableCoordinate>
//    associatedtype CoordinatorNext: CoordinatorProtocol

    var arrayCoordinators: Array<Any>? { get set }

    func start(from viewController: UIViewController) -> Any

    func coordinate< Coordinator: CoordinatorProtocol>(to coordinator: Coordinator, from viewController: UIViewController)  -> Any
}

class AppCoordinatorObser: CoordinatorProtocol {

    var arrayCoordinators: Array<Any>?
    
//    typealias CoordinatorNext = Coordinator1
//    typealias ElementForObservableStart = Void
//    typealias ElementForObservableCoordinate = Void

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

    func start(from viewController: UIViewController) -> Any {

        viewController.rx.viewDidAppear.subscribe(onNext:  {  _ in
            if arc4random_uniform(10) >= 1 {
                self.coordinator1 = Coordinator1.SharedInit(nc: self.nc)
                if self.arrayCoordinators == nil{
                    self.arrayCoordinators = [Any]()
                }
                self.arrayCoordinators!.append(self.coordinator1 as Any)
                (self.coordinate(to: self.coordinator1, from: viewController) as! Observable<Void>).subscribe{ _ in}.disposed(by: self.disposeBag)
                return
            }else{
                //self.coordinate(to: self.anothercoordinator, from: viewController).subscribe{ _ in}.disposed(by: self.disposeBag)
                print("zero !!!")
                return
            }
        }).disposed(by: disposeBag)
        return  Observable<Any>.never() as Any
    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from viewController: UIViewController) -> Any where Coordinator : CoordinatorProtocol {
        return coordinator.start(from: viewController)
    }

}
