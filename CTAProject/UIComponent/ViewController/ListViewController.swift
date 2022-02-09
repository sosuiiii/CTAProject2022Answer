
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

        tableView.register(HotPepperTableViewCell.nib, forCellReuseIdentifier: HotPepperTableViewCell.identifier)
        tableView.backgroundColor = .systemGray6
        datasource = RxTableViewSectionedReloadDataSource<HotPepperResponseDataSource>(
            configureCell: { _, tableView, indexPath, items in
                let cell = tableView.dequeueReusableCell(withIdentifier: HotPepperTableViewCell.identifier, for: indexPath) as! HotPepperTableViewCell
                cell.setupCell(item: items)
                cell.delegate = self
                return cell
            })
        setLayout()

        // Input
        searchView.searchBar.searchTextField.rx.controlEvent([.editingChanged])
            .withLatestFrom(searchView.searchBar.rx.text.orEmpty)
            .bind(to: viewModel.input.searchTextInput)
            .disposed(by: disposeBag)

        searchView.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchView.searchBar.rx.text.orEmpty)
            .bind(to: viewModel.input.searchButtonTapped)
            .disposed(by: disposeBag)

        // Output
        viewModel.output.validatedText
            .bind(to: searchView.searchBar.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.hud
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { type in
                HUD.show(type)
            }).disposed(by: disposeBag)

        viewModel.output.dismissHUD
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext: {
                HUD.hide()
            }).disposed(by: disposeBag)

        viewModel.output.alert
            .observe(on: ConcurrentMainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { me, alertType in
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
