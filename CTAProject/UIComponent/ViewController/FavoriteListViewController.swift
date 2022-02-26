
import UIKit
import PKHUD
import RxCocoa
import RxDataSources
import RxSwift

final class FavoriteListViewController: UIViewController {

    // FatViewController対策と共通化の理由でヘッダー部分を別クラスで定義している
    private let headerView = TabBarControllerHeaderView()
    private let tableView = UITableView()
    private var datasource: RxTableViewSectionedReloadDataSource<FavoriteHotPepperObjectsDataSource>?
    private let disposeBag = DisposeBag()

    // ViewModelをDI
    // storyboardを使っていると若干DIに工夫が必要だった気がする。調べてみて
    private let viewModel: FavoriteListViewModelType
    init(viewModel: FavoriteListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        // UI・layout
        view.backgroundColor = .systemYellow
        view.addSubview(headerView)
        view.addSubview(tableView)

        tableView.register(Const.nib(HotPepperTableViewCell.self), forCellReuseIdentifier: Const.identifier(HotPepperTableViewCell.self))
        tableView.backgroundColor = .systemGray6
        datasource = RxTableViewSectionedReloadDataSource<FavoriteHotPepperObjectsDataSource>(
            configureCell: { _, tableView, indexPath, items in
                let cell = tableView.dequeueReusableCell(withIdentifier: Const.identifier(HotPepperTableViewCell.self), for: indexPath) as! HotPepperTableViewCell
                cell.setupFavorite(item: items)
                cell.favoriteDelegate = self
                return cell
            })
        setLayout()

        // Input

        // Output
        viewModel.output.hud
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { type in
                HUD.show(type)
            }).disposed(by: disposeBag)

        // 表示と非表示は別のイベントとして流してあげたほうが良さそう
        viewModel.output.dismissHUD
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext: {
                HUD.hide()
            }).disposed(by: disposeBag)

        viewModel.output.datasource
            .bind(to: tableView.rx.items(dataSource: datasource!))
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppear.onNext(())
    }
}

extension FavoriteListViewController: HotPepperFavoriteTableViewCellDelegate {

    func removeFavorite(object: ShopObject) {
        viewModel.input.deleteObject.onNext(object.name)
    }

}
