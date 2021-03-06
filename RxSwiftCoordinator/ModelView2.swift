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

class ModelView2: NSObject, ModelView, UITableViewDelegate{

    let disposeBag = DisposeBag()

    var model2: Model2!
    var tableView: UITableView!
    var viewControllerWithTableView: View_ViewController!
    var modelTableViewModel2: ModelTableViewModel2 = ModelTableViewModel2.Shared
    var dataSource: BehaviorSubject<[DataSourceDecemalModelSection]>!
    var editingStyleTableView: UITableViewCell.EditingStyle!

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


    private override init(){
    }
    private convenience init(viewController: UIViewController){
        self.init()
        self.viewControllerWithTableView = (viewController as! View_ViewController)
        Model2.initShared(firstDecade: 1, lastDecade: 2)
        dataSource = Model2.Shared.dataSourceBehaviorSubject
        self.model2 = Model2.Shared
        print("init ModelVeiw2")
    }

    deinit {
        print("deinit ModelVeiw2")
    }
    func binding(){
        self.tableView = self.viewControllerWithTableView.tableView
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        self.dataSource?.asDriver(onErrorRecover: { error -> SharedSequence<DriverSharingStrategy, [DataSourceDecemalModelSection]> in
            print(error)
            return SharedSequence<DriverSharingStrategy, [DataSourceDecemalModelSection]>.just([DataSourceDecemalModelSection.init(numberDecade: 1)])
        }).drive(tableView.rx.items(dataSource: modelTableViewModel2))
            .disposed(by: disposeBag)

        (self.viewControllerWithTableView as UIViewController).rx.viewWillAppear.subscribe(onNext: { _ in
            self.model2.updateToInitial()
        }).disposed(by: disposeBag)

//MARK- BarButton Taps

        self.viewControllerWithTableView.barButtonAddSection.rx.tap.asDriver().drive(self.model2.observerNewSection)
        .disposed(by: self.disposeBag)

        self.viewControllerWithTableView.barButtonEditTableView.rx.tap
            .do(onNext: { _ in
                self.editingStyleTableView = UITableViewCell.EditingStyle.delete
            })
            .bind(to: tableView.rx.edit).disposed(by: self.disposeBag)

        self.viewControllerWithTableView.barButtonAddItem.rx.tap
            .do(onNext: { _ in
                self.editingStyleTableView = UITableViewCell.EditingStyle.insert
            })
            .bind(to: tableView.rx.edit).disposed(by: self.disposeBag)

//MARK- Actions 

        tableView.rx.itemInserted.asDriver().drive(model2.observerItemInserted).disposed(by: disposeBag)

        tableView.rx.itemSelected.asDriver().drive(model2.itemSelectedPublishSubject).disposed(by: self.disposeBag)

        tableView.rx.itemMoved.asDriver { (error) -> SharedSequence<DriverSharingStrategy, (sourceIndex: IndexPath, destinationIndex: IndexPath)> in
            SharedSequence<DriverSharingStrategy, (sourceIndex: IndexPath, destinationIndex: IndexPath)>.just((sourceIndex: IndexPath.init(row: 0, section: 0), destinationIndex: IndexPath.init(row: 0, section: 0)))
        }.drive(model2.observerItemMoved).disposed(by: disposeBag)

        tableView.rx.itemDeleted.asDriver().drive(model2.observerItemDeleted).disposed(by: disposeBag)

        

    }

    //MARK- Delegate Table View

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        print(self.editingStyleTableView.rawValue)
        return  self.editingStyleTableView
    }

    func tableView(_ tableView: UITableView, commitEditingStyle indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return  self.editingStyleTableView
    }

    

}
