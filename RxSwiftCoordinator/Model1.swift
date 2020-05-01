//
//  Model.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 28.04.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class Model1{

    public static var Shared = Model1()
    private let disposeBag = DisposeBag()

    public var observerChangeSourceArray: AnyObserver<IndexPath>!

    public var observableSourceArray: Observable<[Int]>  = Observable.create { (observer) -> Disposable in
        var array = [Int]()
        for i in 0...100{
            array.append(i)
        }
        observer.onNext(array)
        return Disposables.create()
    }

    public var initialObservableSourceArray: Observable<[Int]>!

    public var replaySubjectSourceArray: ReplaySubject<[Int]> = ReplaySubject<[Int]>.create(bufferSize: 1)

    private var disposereplaySubjectSourceArray: Disposable!

    init( _ a: Int){
        print("init Model1")
    }
    deinit {
        print("deinit Model1")
    }

    private convenience init(){
        self.init(0)
        initialObservableSourceArray = self.observableSourceArray
        self.observerChangeSourceArray = AnyObserver<IndexPath>.init(eventHandler: { [unowned self] event in
            switch event{
            case .next:
                let indexChangeArray = event.element!.row
                self.observableSourceArray = self.observableSourceArray.map({ array in
                    var arrayMut = array
                    let num = arrayMut.remove(at: indexChangeArray)
                    arrayMut.insert(num * indexChangeArray, at: indexChangeArray)
                    return arrayMut
                })

                if self.disposereplaySubjectSourceArray != nil{
                    self.disposereplaySubjectSourceArray.dispose()
                }
                self.disposereplaySubjectSourceArray = self.observableSourceArray.subscribe(self.replaySubjectSourceArray)

            case .error(_):
                print("error")
            case .completed: break
            }

        })

    }

    public func updateToInitial(){
        self.observableSourceArray = self.initialObservableSourceArray
        self.observableSourceArray.subscribe(self.replaySubjectSourceArray).disposed(by: self.disposeBag)
    }

}
