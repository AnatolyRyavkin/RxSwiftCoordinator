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

    private static var SharedInvoke: Model2?

    public var itemSelectedPublishSubject: PublishSubject<IndexPath> = PublishSubject<IndexPath>.init()

    private lazy var observerItemSelected: AnyObserver<IndexPath> = AnyObserver.init { (event) in
//        self.sourceData = self.sourceData.map({ data in
//            return data
//        })
        self.sourceData = Observable<[DataSourceDecemalModelSection]>.create{ observer in
            var tempArray = [DataSourceDecemalModelSection]()
            for i in 0...10{
                tempArray.append(DataSourceDecemalModelSection.init(numberDecade: i))
            }
            observer.onNext(tempArray)
            return Disposables.create()
        }
    }

    public static var Shared: Model2{
        if Model2.SharedInvoke == nil{
            Model2.SharedInvoke = Model2.init(firstDecade: 0, lastDecade: 9)
            print("Model2 designate from 0 to 100 !!!")
        }
        return SharedInvoke!
    }
    private let disposeBag = DisposeBag()
    var sourceData: Observable<[DataSourceDecemalModelSection]>!

    private init( _ a: Int?){
        print("init Model2")
    }
    deinit {
        print("deinit Model2")
    }
    public convenience init(firstDecade: Int, lastDecade: Int){
        self.init(0)
        sourceData = Observable<[DataSourceDecemalModelSection]>.create{ observer in
            var tempArray = [DataSourceDecemalModelSection]()
            for i in firstDecade...lastDecade{
                tempArray.append(DataSourceDecemalModelSection.init(numberDecade: i))
            }
            observer.onNext(tempArray)
            return Disposables.create()
        }
        Model2.SharedInvoke = self
        self.itemSelectedPublishSubject.asDriver { (error) -> SharedSequence<DriverSharingStrategy, IndexPath> in
            print("itemSelectedPublishSubject.asDriver - error: \(error)")
            return SharedSequence.just(IndexPath.init(row: 0, section: 0))
            }
        .debug("ip", trimOutput: false)
        .drive(self.observerItemSelected).disposed(by: disposeBag)

        self.itemSelectedPublishSubject.subscribe(onNext: { (ip) in
            print(ip)
        })
    }

    public static func initShared(firstDecade: Int, lastDecade: Int){
        _ = Model2.init(firstDecade: firstDecade, lastDecade: lastDecade)
    }
}











