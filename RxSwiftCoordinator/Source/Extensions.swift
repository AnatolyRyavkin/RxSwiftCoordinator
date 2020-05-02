//
//  Extensions.swift
//  RxSwiftCoordinator
//
//  Created by Anatoly Ryavkin on 29.04.2020.
//  Copyright © 2020 AnatolyRyavkin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base == UIViewController{

    private func controlEvent(for selector: Selector) -> ControlEvent<Void> {
        return ControlEvent(events: sentMessage(selector).map{ _ in})
    }

    public var viewWillAppear: ControlEvent<Void>{
        return controlEvent(for: #selector(UIViewController.viewWillAppear))
    }

    var viewDidAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidAppear))
    }

    var viewWillDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewWillDisappear))
    }

    var viewDidDisappear: ControlEvent<Void> {
        return controlEvent(for: #selector(UIViewController.viewDidDisappear))
    }

}

extension UIView{
    func findCell() -> UITableViewCell?{
        if self.subviews.count > 0{
            for subView in self.subviews{
                if subView is UITableViewCell{
                    return subView as? UITableViewCell
                }else{
                    return subView.findCell()
                }
            }
        }
        return nil
    }
}
