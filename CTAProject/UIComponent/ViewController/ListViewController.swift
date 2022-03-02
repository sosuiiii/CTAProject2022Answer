
import UIKit
import PKHUD
import RxCocoa
import RxDataSources
import RxSwift

final class ListViewController: UIViewController {

    private let headerView = TabBarControllerHeaderView()
    private let searchView = TabBarControllerSearchView()
    private let tableView = UITableView()
    private var datasource: RxTableViewSectionedReloadDataSource<HotPepperResponseDataSource>?
    private let disposeBag = DisposeBag()

    private let viewModel: ListViewModelType
    init(viewModel: ListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        // UI・layout
        view.backgroundColor = .systemYellow
        view.addSubview(headerView)
        view.addSubview(searchView)
        view.addSubview(tableView)

        tableView.register(Const.nib(HotPepperTableViewCell.self), forCellReuseIdentifier: Const.identifier(HotPepperTableViewCell.self))
        tableView.backgroundColor = .systemGray6
        datasource = RxTableViewSectionedReloadDataSource<HotPepperResponseDataSource>(
            configureCell: { _, tableView, indexPath, items in
                let cell = tableView.dequeueReusableCell(withIdentifier: Const.identifier(HotPepperTableViewCell.self), for: indexPath) as! HotPepperTableViewCell
                cell.setupCell(item: items)
                cell.delegate = self
                return cell
            })
        setLayout()

        // Input
        searchView.searchBar.rx.text.orEmpty
            .bind(to: viewModel.input.searchBarText)
            .disposed(by: disposeBag)

        searchView.searchBar.searchTextField.rx.controlEvent([.editingChanged])
            .bind(to: viewModel.input.searchBarEditingChanged)
            .disposed(by: disposeBag)

        searchView.searchBar.rx.searchButtonClicked
            .bind(to: viewModel.input.searchButtonClicked)
            .disposed(by: disposeBag)

        // Output
        viewModel.output.validatedText
            .bind(to: searchView.searchBar.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.hud
            .subscribe(onNext: { type in
                HUD.show(type)
            }).disposed(by: disposeBag)

        viewModel.output.dismissHUD
            .subscribe(onNext: {
                HUD.hide()
            }).disposed(by: disposeBag)

        viewModel.output.alert
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(with: self, onNext: { me, alertType in
                me.searchView.endEditing(true)
                if case .textCountOver = alertType {
                    let alertView = AlertView(message: L10n.charactersExceeds50)
                    me.showView(view: alertView)
                }
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
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchView.heightAnchor.constraint(equalToConstant: searchView.heightConst)
        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ListViewController: HotPepperTableViewCellDelegate {

    func addFavorite(item: Shop) {
        viewModel.input.saveFavorite.onNext(item)
    }

    func removeFavorite(item: Shop) {
        viewModel.input.deleteObject.onNext(item.name)
    }
}
