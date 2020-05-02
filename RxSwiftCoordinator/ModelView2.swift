//
//  ModelView2.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 01.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import UIKit

class ModelView2: ModelView{

    let disposeBag = DisposeBag()

    var model2: Model2!
    var tableView: UITableView!
    var viewControllerWithTableView: View_ViewController!
    var modelTableViewModel2: ModelTableViewModel2 = ModelTableViewModel2.Shared
    var dataSource: Observable<[DataSourceDecemalModelSection]>! 

    //MARK: Singleton begin

    private static var instance: ModelView2?

    public static var Shared: ModelView2{
        if ModelView2.instance == nil{
            #if DEBUG
                print("AppCoordinatorObser is empty, execute SharedInit !!!")
                fatalError()
            #else
                _ = ModelView2.SharedInit(viewController: UIViewController())
            #endif
        }
        return ModelView2.instance!
    }

    public static func SharedInit(viewController: UIViewController) -> ModelView2{
        if ModelView2.instance == nil{
            ModelView2.instance = ModelView2.init(viewController: viewController)
        }
        return ModelView2.instance!
    }

    //MARK: Singleton end


    private init(){
        print("init ModelView2")
    }
    private convenience init(viewController: UIViewController){
        self.init()
        self.viewControllerWithTableView = (viewController as! View_ViewController)
        Model2.initShared(firstDecade: 50, lastDecade: 1000)
        dataSource = Model2.Shared.sourceData
        self.model2 = Model2.Shared
        print("init ModelVeiw2")
    }

    deinit {
        print("deinit ModelVeiw2")
    }
    func binding(){
        self.tableView = self.viewControllerWithTableView.tableView
        self.dataSource?.asDriver(onErrorRecover: { error -> SharedSequence<DriverSharingStrategy, [DataSourceDecemalModelSection]> in
            print(error)
            return SharedSequence<DriverSharingStrategy, [DataSourceDecemalModelSection]>.just([DataSourceDecemalModelSection.init(numberDecade: 1)])
        }).drive(tableView.rx.items(dataSource: modelTableViewModel2)).disposed(by: disposeBag)

        tableView.rx.itemSelected.asDriver().drive(model2.itemSelectedPublishSubject).disposed(by: self.disposeBag)




    }
}


