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

//MARK Change

    mutating func changeMultipleElementAtIndexPath(indexPath: IndexPath, newElement: Int?) { //}-> DataSourceDecemalModelSection{
        if let num = newElement{
            self.decade.remove(at: indexPath.row)
            self.decade.insert(num, at: indexPath.row)
        }else{
            let element = self.decade.remove(at: indexPath.row)  //(self.decade.remove(at: indexPath.row)) * (self.numberDecade * 10 + indexPath.row)
            self.decade.insert(element * element, at: indexPath.row)
        }
        //return self
    }

    mutating func insertElementToIndexPath(indexPath: IndexPath, newElement: Int?) { //-> DataSourceDecemalModelSection{
        if let num = newElement{
            if indexPath.row < self.decade.count{
                self.decade.insert(num, at: indexPath.row)
            }else{
                self.decade.append(num)
            }
        }else{
            let oldNum = self.decade[indexPath.row]
            if indexPath.row < self.decade.count{
                self.decade.insert(oldNum, at: indexPath.row)
            }else{
                self.decade.append(oldNum)
            }
        }
        //return self
    }

    mutating func deleteElementToIndexPath(indexPath: IndexPath) -> Int{
        let num = self.decade.remove(at: indexPath.row)
        return num
    }


}




