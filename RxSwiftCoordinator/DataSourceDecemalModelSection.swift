//
//  DataSourceDecemalModel.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 01.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxDataSources


struct DataSourceDecemalModelSection {
    var decade: [Int]
    var numberDecade: Int
    init(numberDecade: Int){
        self.numberDecade = numberDecade
        self.decade = [Int]()
        for i in 0...9{
            self.decade.append(numberDecade*10 + i)
        }
    }
}

//MARK protocol

extension DataSourceDecemalModelSection: AnimatableSectionModelType{
    typealias Item = Int
    typealias Identity = Int
    var items: [Item]{
        return decade
    }
    var identity: Int{
        return numberDecade
    }
    init(original: DataSourceDecemalModelSection, items: [Item]) {
        self = original
        decade = items
    }
}
