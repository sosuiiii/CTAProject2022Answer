import UIKit

extension UITableViewCell {
    static let nib = UINib(nibName: String(describing: self), bundle: nil)
    static let identifier = String(describing: self)
}
