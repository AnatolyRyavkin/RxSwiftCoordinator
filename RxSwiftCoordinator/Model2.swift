//
//  Model2.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 01.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

//
//  Model.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 28.04.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa
import UIKit

class Model2{

    enum EnumOperationWithDataSourceBehaviorSubject {
        case setNewSectionAtBegin
        case setNewElementForIndexPath(IndexPath, Int? = nil )
        case changeElementByAnother(IndexPath, Int? = nil)
        case deleteElement(IndexPath)
        case moveElement(IndexPath, IndexPath)
    }

    private static var SharedInvoke: Model2?

    private let disposeBag = DisposeBag()
    private var data: [DataSourceDecemalModelSection]!
    private var dataInitial: [DataSourceDecemalModelSection]!
    var dataSourceBehaviorSubject: BehaviorSubject<[DataSourceDecemalModelSection]>!

    public var itemSelectedPublishSubject: PublishSubject<IndexPath> = PublishSubject<IndexPath>.init()

    private lazy var observerItemSelected: AnyObserver<IndexPath> = AnyObserver.init { (event) in
        switch event{
        case .next:
            let indexPath = event.element!
            self.changeDataSourceBehaviorSubject(typeOperation: .changeElementByAnother(indexPath))
        case .error(_):
            print("error")
        case .completed:
            break
        }
    }

    public lazy var observerItemMoved: AnyObserver<(sourceIndex: IndexPath, destinationIndex: IndexPath)> = AnyObserver.init { (event) in
        switch event{
        case .next:
            let fromIndexPath = event.element!.sourceIndex
            let toIndexPath = event.element!.destinationIndex
            self.changeDataSourceBehaviorSubject(typeOperation: .moveElement(fromIndexPath, toIndexPath))
        case .error(_):
            print("error")
        case .completed:
            break
        }
    } 

    public lazy var observerItemDeleted: AnyObserver<IndexPath> = AnyObserver.init { (event) in
        switch event{
        case .next:
            let indexPath = event.element!
            self.changeDataSourceBehaviorSubject(typeOperation: .deleteElement(indexPath))
        case .error(_):
            print("error")
        case .completed:
            break
        }
    } 

    public lazy var observerItemInserted: AnyObserver<IndexPath> = AnyObserver.init { (event) in
        switch event{
        case .next:
            let indexPath = event.element!
            self.changeDataSourceBehaviorSubject(typeOperation: .setNewElementForIndexPath(indexPath))
        case .error(_):
            print("error")
        case .completed:
            break
        }
    }

    public lazy var observerNewSection: AnyObserver<Void> = AnyObserver.init { event in
        switch event{
        case .next:
            self.changeDataSourceBehaviorSubject(typeOperation: .setNewSectionAtBegin)
        case .error(_):
            print("error")
        case .completed:
            break
        }
    }
    
    public static var Shared: Model2{
        if Model2.SharedInvoke == nil{
            Model2.SharedInvoke = Model2.init(firstDecade: 0, lastDecade: 9)
            print("Model2 designate from 0 to 100 !!!")
        }
        return SharedInvoke!
    }


    private init( _ a: Int?){
        print("init Model2")
    }
    deinit {
        print("deinit Model2")
    }
    public convenience init(firstDecade: Int, lastDecade: Int){
        self.init(0)
        var tempArray = [DataSourceDecemalModelSection]()
        for i in firstDecade...lastDecade{
            tempArray.append(DataSourceDecemalModelSection.init(numberDecade: i))
        }
        self.data = tempArray
        self.dataInitial = tempArray
        Model2.SharedInvoke = self

        dataSourceBehaviorSubject = BehaviorSubject.init(value: self.data)

        self.itemSelectedPublishSubject.asDriver { (error) -> SharedSequence<DriverSharingStrategy, IndexPath> in
            print("itemSelectedPublishSubject.asDriver - error: \(error)")
            return SharedSequence.just(IndexPath.init(row: 0, section: 0))
            }
        .drive(self.observerItemSelected).disposed(by: disposeBag)
    }

    public static func initShared(firstDecade: Int, lastDecade: Int){
        _ = Model2.init(firstDecade: firstDecade, lastDecade: lastDecade)
    }

    func changeDataSourceBehaviorSubject(typeOperation: EnumOperationWithDataSourceBehaviorSubject){

        var tempArrayDataSourse = self.data!
        switch typeOperation {
        case .setNewSectionAtBegin:
            tempArrayDataSourse.insert(DataSourceDecemalModelSection.init(numberDecade: 0), at: 0)
        case .setNewElementForIndexPath(let indexPath, let newElement):
            var changeSection = tempArrayDataSourse.remove(at: indexPath.section)
            changeSection.insertElementToIndexPath(indexPath: indexPath, newElement: newElement)
            tempArrayDataSourse.insert(changeSection, at: indexPath.section)
        case .changeElementByAnother(let indexPath, let newElement):
            var changeSection = tempArrayDataSourse.remove(at: indexPath.section)
            changeSection.changeMultipleElementAtIndexPath(indexPath: indexPath, newElement: newElement)
            tempArrayDataSourse.insert(changeSection, at: indexPath.section)
        case .deleteElement(let indexPath):
            var changeSection = tempArrayDataSourse.remove(at: indexPath.section)
            _ = changeSection.deleteElementToIndexPath(indexPath: indexPath)
            tempArrayDataSourse.insert(changeSection, at: indexPath.section)
        case .moveElement(let fromIndexPath, let toIndexPath):
            var changeSection = tempArrayDataSourse.remove(at: fromIndexPath.section)
            let element = changeSection.deleteElementToIndexPath(indexPath: fromIndexPath)
            changeSection.insertElementToIndexPath(indexPath: toIndexPath, newElement: element)
            tempArrayDataSourse.insert(changeSection, at: toIndexPath.section)
        }

        self.data = tempArrayDataSourse
        self.dataSourceBehaviorSubject.onNext(self.data)

    }

    public func updateToInitial(){
        self.data = self.dataInitial
        self.dataSourceBehaviorSubject.onNext(self.data)
    }
}

