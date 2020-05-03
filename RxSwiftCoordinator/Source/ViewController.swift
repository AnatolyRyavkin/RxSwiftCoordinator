//
//  ViewController.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 27.04.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    deinit {
        print("deinit ViewController")
    }

    convenience init() {
        self.init(nibName:nil, bundle:nil)
        print("init ViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

