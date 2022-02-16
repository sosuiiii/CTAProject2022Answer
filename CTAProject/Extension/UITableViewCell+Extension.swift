import UIKit

extension UITableViewCell {
    static let nib = UINib(nibName: String(describing: self), bundle: nil)
    static func nib<T: UITableViewCell>(_ tableViewCell: T) -> UINib {
        return UINib(nibName: String(describing: T.self), bundle: nil)
    }
    static func identifier<T: UITableViewCell>(_ tableViewCell: T) -> String {
        return String(describing: T.self)
    }
    static let identifier = String(describing: self)
}
