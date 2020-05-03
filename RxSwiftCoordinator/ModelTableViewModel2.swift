//
//  ModelTableViewModel2.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 01.05.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa
import UIKit

class ModelTableViewModel2: RxTableViewSectionedReloadDataSource<DataSourceDecemalModelSection>{

    private let disposeBag = DisposeBag()

    static let Shared: ModelTableViewModel2 = {

        let configureCell: ModelTableViewModel2.ConfigureCell = { (dataSource, tableView, indexPath, item) -> UITableViewCell in

            var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")

            if cell == nil{
                var tvc_View = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vc") as! View_ViewController
                cell = tvc_View.view.findCell()
            }

            cell?.textLabel!.text = String(item)

            return cell!
        }

        let configureHeaderSection: ModelTableViewModel2.TitleForHeaderInSection = { (dataSource, numberSection) -> String? in
            return "Decade - \(dataSource[numberSection].identity)"
        }

        let sectionIndexTitles: ModelTableViewModel2.SectionIndexTitles = { (dataSource) -> [String]? in
            let arrayString = dataSource.sectionModels.map{
                "\($0.identity)"
            }
            return arrayString
        }

        let sectionForSectionIndexTitle: ModelTableViewModel2.SectionForSectionIndexTitle = { (dataSource, string, index) -> Int in
            /// return dataSource[index].identity
            /// move at SectionIndex to return ... section identity, string - name section from array sectionIndexTitles
            return index
        }

        let cell = ModelTableViewModel2.init(configureCell: configureCell,
                                             titleForHeaderInSection: configureHeaderSection,
                                             titleForFooterInSection: { (dataSource, indexPath) -> String? in nil},
                                             canEditRowAtIndexPath: { (dataSource, indexPath) -> Bool in true},
                                             canMoveRowAtIndexPath: { (dataSource, indexPath) -> Bool in true},
                                             sectionIndexTitles: sectionIndexTitles,
                                             sectionForSectionIndexTitle: sectionForSectionIndexTitle
        )

        return cell

    }()

}
