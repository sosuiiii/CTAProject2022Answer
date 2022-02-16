//
//  Extension.swift
//  CTAProject
//
//  Created by 田中 颯志 on 2022/01/01.
//

import Foundation
import UIKit

extension UIViewController {
    func showView(view: UIView) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        transition.subtype = .fromTop
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.layer.add(transition, forKey: kCATransition)
        window?.addSubview(view)
    }
    struct Const {
        static func nib<T: UITableViewCell>(_ tableViewCell: T.Type) -> UINib {
            return UINib(nibName: String(describing: T.self), bundle: nil)
        }
        static func identifier<T: UITableViewCell>(_ tableViewCell: T.Type) -> String {
            return String(describing: T.self)
        }
    }
}
