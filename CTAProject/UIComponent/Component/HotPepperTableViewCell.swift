//
//  HotPepperResponseTableViewCell.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import UIKit
import SDWebImage

protocol HotPepperTableViewCellDelegate: AnyObject {
    func addFavorite(item: Shop)
    func removeFavorite(item: Shop)
}
protocol HotPepperFavoriteTableViewCellDelegate: AnyObject {
    func removeFavorite(object: ShopObject)
}

class HotPepperTableViewCell: UITableViewCell {


    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var genreAndStation: UILabel!
    @IBOutlet weak var starIcon: UIImageView!
    private var noImageURL = URL(string: "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png")
    weak var delegate: HotPepperTableViewCellDelegate?
    weak var favoriteDelegate: HotPepperFavoriteTableViewCellDelegate?
    private var shop: Shop?
    private var object: ShopObject?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupCell(item: Shop) {
        shop = item
        setImageBySDWebImage(with: item.logoImage ?? noImageURL)
        name.text = item.name
        budget.text = item.budget?.name
        genreAndStation.text = "\(item.genre.name)/\(item.stationName ?? "")駅"

        let objects = RealmManager().getEntityList(type: ShopObject.self)
        let objectNameList = objects.map { $0.name }
        if objectNameList.contains(item.name) {
            starIcon.tag = 1
            starIcon.image = Asset.starOn.image
        } else {
            starIcon.image = Asset.starOff.image
        }
    }

    func setupFavorite(item: ShopObject) {
        object = item
        starIcon.tag = 1
        starIcon.image = Asset.starOn.image
        setImageBySDWebImage(with: URL(string: item.logoImage))
        name.text = item.name
        budget.text = item.budgetName
        genreAndStation.text = "\(item.genre)/\(item.station)駅"
    }

    private func setImageBySDWebImage(with url: URL?) {
        logoImage.sd_setImage(with: url) { [weak self] image, error, _, _ in
            if error == nil, let image = image {
                self?.logoImage.image = image
            } else {
                print("sd_webImage::error:\(String(describing: error))")
            }
        }
    }
    @IBAction func starTapped(_ sender: Any) {
        if starIcon.tag == 0 {
            starIcon.tag = 1
            starIcon.image = Asset.starOn.image
            if let shop = shop {
                delegate?.addFavorite(item: shop)
            }
        } else {
            starIcon.tag = 0
            starIcon.image = Asset.starOff.image
            if let shop = shop {
                delegate?.removeFavorite(item: shop)
            } else if let object = object {
                favoriteDelegate?.removeFavorite(object: object)
            }
        }
    }

}
