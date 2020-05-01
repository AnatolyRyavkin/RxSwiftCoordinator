//
//  Coordinator1.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 29.04.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import UIKit

class Coordinator1: CoordinatorProtocol{





    typealias CoordinatorNext = Coordinator11
    typealias ElementForObservableStart = Void
    typealias ElementForObservableCoordinate = IndexPath

    var arrayCoordinators: Array<Any>?

    var coordinator11: Coordinator11!
    private let disposeBag = DisposeBag()
    private var disposableObsAlert: Disposable!
    private var coordinator11StartDisposable: Disposable!
    var nc: UINavigationController
    var tvc_View: View_ViewController
    var modelView1: ModelView1!
    var subscriberModelViewPublshSubject: Disposable!

    //MARK: Singleton begin

    private static var instance: Coordinator1?

    public static var Shared: Coordinator1{
        if Coordinator1.instance == nil{
            #if DEBUG
                print("AppCoordinatorObser is empty, execute SharedInit !!!")
                fatalError()
            #else
                _ = Coordinator1.SharedInit(nc: UINavigationController())
            #endif
        }
        return Coordinator1.instance!
    }

    public static func SharedInit(nc: UINavigationController) -> Coordinator1{
        if Coordinator1.instance == nil{
            Coordinator1.instance = Coordinator1.init(nc: nc)
        }
        return Coordinator1.instance!
    }

    //MARK: Singleton end

    private init(nc: UINavigationController){
        self.nc = nc
        tvc_View = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc") as! View_ViewController
        modelView1 = ModelView1.SharedInit(viewController: tvc_View)
        tvc_View.modelView = modelView1
        tvc_View.view.backgroundColor = UIColor.blue
        print("init Coordinator1")
    }
    deinit {
        print("deinit Coordinator1")
    }

    func start(from viewController: UIViewController) -> Any {

        if self.disposableObsAlert == nil {
            self.coordinator11 = Coordinator11.SharedInit(publishSubject: self.modelView1.publishSubjectSelectedRow)
            self.disposableObsAlert = (self.coordinate(to: self.coordinator11, from: self.tvc_View) as! Observable<Any>).subscribe{ _ in }
        }
        nc.pushViewController(self.tvc_View, animated: true)

        return Observable<Any>.never() as Any
    }

//    func coordinate(to coordinator: CoordinatorNext, from viewController: UIViewController) -> Any {
//        coordinator11StartDisposable = coordinator11.start(from: viewController).subscribe{ _ in }
//        return Observable<Any>.empty() as Any
//    }

    func coordinate<Coordinator>(to coordinator: Coordinator, from viewController: UIViewController) -> Any where Coordinator : CoordinatorProtocol {
        coordinator11StartDisposable = coordinator11.start(from: viewController).subscribe{ _ in }
        return Observable<Any>.empty() as Any
    }

}

