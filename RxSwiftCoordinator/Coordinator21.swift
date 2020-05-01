//
//  Coordinator21.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 01.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class Coordinator21: CoordinatorProtocol{

    typealias CoordinatorNext = Coordinator21
    typealias Element = Void

    var arrayCoordinators: Array<Coordinator21>?

    private let disposeBag = DisposeBag()
    private var viewController: View_ViewController!
    private var observerForAllert: AnyObserver<IndexPath>!
    private var publishSubject: PublishSubject<IndexPath>!

    //MARK: Singleton begin

       private static var instance: Coordinator21?

       public static var Shared: Coordinator21{
           if Coordinator21.instance == nil{
               #if DEBUG
                   print("AppCoordinatorObser is empty, execute SharedInit !!!")
                   fatalError()
               #else
                   _ = Coordinator21.SharedInit(indexPath: IndexPath())
               #endif
           }
           return Coordinator21.instance!
       }

       public static func SharedInit(publishSubject: PublishSubject<IndexPath>) -> Coordinator21{
           if Coordinator21.instance == nil{
               Coordinator21.instance = Coordinator21.init(publishSubject: publishSubject)
           }
           return Coordinator21.instance!
       }

       //MARK: Singleton end

    private init(){

    }

    private convenience init(publishSubject: PublishSubject<IndexPath>){
        self.init()
        self.publishSubject = publishSubject
        observerForAllert = AnyObserver<IndexPath>.init { event in
            let indexPath = event.element!
            let alert = UIAlertController(title: "Alert", message: "IndexPath --- \(indexPath)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                        break
                  case .cancel:
                        print("cancel")
                  case .destructive:
                        print("destructive")
                  @unknown default:
                    fatalError()
                }}))
            self.viewController.present(alert, animated: true, completion: nil)
        }
        print("init Coordinator21")
    }


    deinit {
        print("deinit Coordinator21")
    }

    func start(from viewController: UIViewController) -> Observable<Element> {

        self.viewController = viewController as? View_ViewController
        if self.viewController == nil{
            print("My Fatal Error")
            fatalError()
        }
        self.publishSubject.asDriver(onErrorJustReturn: IndexPath.init(row: 0 , section: 0)).drive(self.observerForAllert)
        .disposed(by: self.disposeBag)
        return Observable.empty()
    }

    public func coordinate(to coordinator: CoordinatorNext , from viewController: UIViewController) -> Observable<Void> {
        return coordinator.start(from: viewController)
    }

}

