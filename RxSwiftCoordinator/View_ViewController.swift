//
//  View_TableViewController.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 28.04.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation


class View_ViewController: UIViewController, ProtocolObservableViewController{

    private let disposeBag = DisposeBag()
    var modelView: ModelView!

    @IBOutlet weak var tableView: UITableView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init View_ViewController")
    }
    deinit {
        print("init View_ViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //modelView = ModelView1.SharedInit(viewController: self)
        modelView.binding()
    }

}
