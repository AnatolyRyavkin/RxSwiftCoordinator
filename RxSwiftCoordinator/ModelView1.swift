//
//  ModelView1.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 29.04.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class ModelView1: ModelView{

    let disposeBag = DisposeBag()

    var model1: Model1!
    var tableView: UITableView!
    var viewControllerWithTableView: View_ViewController!
    var publishSubjectSelectedRow = PublishSubject<IndexPath>()
    var br: BehaviorRelay<Observable<[Int]>> = BehaviorRelay.init(value: Observable.just([1,2,3,4,5,6,7,8,9,10]))
    var observerSelectRow: AnyObserver<IndexPath>!
    var disposableBindingTableView: Disposable!

    //MARK: Singleton begin

    private static var instance: ModelView1?

    public static var Shared: ModelView1{
        if ModelView1.instance == nil{
            #if DEBUG
                print("AppCoordinatorObser is empty, execute SharedInit !!!")
                fatalError()
            #else
                _ = ModelView1.SharedInit(viewController: UIViewController())
            #endif
        }
        return ModelView1.instance!
    }

    public static func SharedInit(viewController: UIViewController) -> ModelView1{
        if ModelView1.instance == nil{
            ModelView1.instance = ModelView1.init(viewController: viewController)
        }
        return ModelView1.instance!
    }

    //MARK: Singleton end


    private init(){

    }
    private convenience init(viewController: UIViewController){
        self.init()
        self.viewControllerWithTableView = (viewController as! View_ViewController)
        self.model1 = Model1.Shared
        print("init ModelVeiw1")
    }

    deinit {
        print("deinit ModelVeiw1")
    }

    func binding(){
        
        self.tableView = self.viewControllerWithTableView.tableView

        (self.viewControllerWithTableView as UIViewController).rx.viewWillAppear.subscribe(onNext: { _ in

            self.model1.updateToInitial()
            
            if self.disposableBindingTableView != nil{
                self.disposableBindingTableView.dispose()
            }

            self.disposableBindingTableView = self.model1.replaySubjectSourceArray.bind(to: self.tableView.rx.items(cellIdentifier: "cell")){row, num, cell in
                cell.textLabel!.text = String(num)
            }
        }).disposed(by: self.disposeBag)

       tableView.rx.itemSelected.bind(to: self.publishSubjectSelectedRow).disposed(by: disposeBag)

        self.publishSubjectSelectedRow.subscribe(self.model1.observerChangeSourceArray).disposed(by: disposeBag)

        self.observerSelectRow = AnyObserver<IndexPath>.init(eventHandler: { event in
            switch event{
            case .next :
            self.disposableBindingTableView.dispose()
            self.disposableBindingTableView = self.model1.replaySubjectSourceArray.bind(to: self.tableView.rx.items(cellIdentifier: "cell")){row, num, cell in
                cell.textLabel!.text = String(num)
            }

            case .error(_):
                print("error")
                #if DEBUG
                    fatalError()
                #endif
            case .completed: break
            }
        })

        self.publishSubjectSelectedRow.subscribe(self.observerSelectRow).self.disposed(by: disposeBag)

    }
}
