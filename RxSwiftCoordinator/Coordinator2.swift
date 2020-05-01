//
//  Coordinator2.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 01.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import UIKit

class Coordinator2: CoordinatorProtocol{

    typealias CoordinatorNext = Coordinator21
    typealias ElementForObservableStart = Void
    typealias ElementForObservableCoordinate = IndexPath

    var arrayCoordinators: Array<Coordinator21>?

    var coordinator21: Coordinator21!
    private let disposeBag = DisposeBag()
    private var disposableObsAlert: Disposable!
    private var coordinator21StartDisposable: Disposable!
    var nc: UINavigationController
    var tvc_View: View_ViewController
    var modelView1: ModelView1!
    var subscriberModelViewPublshSubject: Disposable!

    //MARK: Singleton begin

    private static var instance: Coordinator2?

    public static var Shared: Coordinator2{
        if Coordinator2.instance == nil{
            #if DEBUG
                print("AppCoordinatorObser is empty, execute SharedInit !!!")
                fatalError()
            #else
                _ = Coordinator2.SharedInit(nc: UINavigationController())
            #endif
        }
        return Coordinator2.instance!
    }

    public static func SharedInit(nc: UINavigationController) -> Coordinator2{
        if Coordinator2.instance == nil{
            Coordinator2.instance = Coordinator2.init(nc: nc)
        }
        return Coordinator2.instance!
    }

    //MARK: Singleton end

    private init(nc: UINavigationController){
        self.nc = nc
        tvc_View = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc") as! View_ViewController
        modelView1 = ModelView1.SharedInit(viewController: tvc_View)
        tvc_View.modelView = modelView1
        tvc_View.view.backgroundColor = UIColor.blue
        print("init Coordinator2")
    }
    deinit {
        print("deinit Coordinator2")
    }

    func start(from viewController: UIViewController) -> Observable<Void> {

        if self.disposableObsAlert == nil {
            self.coordinator21 = Coordinator21.SharedInit(publishSubject: self.modelView1.publishSubjectSelectedRow)
            self.disposableObsAlert = self.coordinate(to: self.coordinator21, from: self.tvc_View).subscribe{ _ in }
        }
        nc.pushViewController(self.tvc_View, animated: true)

        return Observable.never()
    }

    func coordinate(to coordinator: CoordinatorNext, from viewController: UIViewController) -> Observable<IndexPath> {
        coordinator21StartDisposable = coordinator21.start(from: viewController).subscribe{ _ in }
        return Observable.empty()
    }

}

