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


class View_ViewController: UIViewController, ProtocolExistTableView{

    private let disposeBag = DisposeBag()
    var modelView: ModelView!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barButtonAddSection: UIBarButtonItem!
    @IBOutlet weak var barButtonEditTableView: UIBarButtonItem!
    @IBOutlet weak var barButtonAddItem: UIBarButtonItem!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init View_ViewController")
    }
    deinit {
        print("init View_ViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        modelView.binding()
    }
}


