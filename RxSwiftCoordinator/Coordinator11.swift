//
//  Coordinator2.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 29.04.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class Coordinator11: CoordinatorProtocol{

    typealias CoordinatorNext = Coordinator11
    typealias Element = Void

    var arrayCoordinators: Array<Coordinator11>?

    private let disposeBag = DisposeBag()
    private var viewController: View_ViewController!
    private var observerForAllert: AnyObserver<IndexPath>!
    private var publishSubject: PublishSubject<IndexPath>!

    //MARK: Singleton begin

       private static var instance: Coordinator11?

       public static var Shared: Coordinator11{
           if Coordinator11.instance == nil{
               #if DEBUG
                   print("AppCoordinatorObser is empty, execute SharedInit !!!")
                   fatalError()
               #else
                   _ = Coordinator2.SharedInit(indexPath: IndexPath())
               #endif
           }
           return Coordinator11.instance!
       }

       public static func SharedInit(publishSubject: PublishSubject<IndexPath>) -> Coordinator11{
           if Coordinator11.instance == nil{
               Coordinator11.instance = Coordinator11.init(publishSubject: publishSubject)
           }
           return Coordinator11.instance!
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
        print("init Coordinator11")
    }


    deinit {
        print("deinit Coordinator11")
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
