
import UIKit

final class TopTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = .white
        UITabBar.appearance().tintColor = .systemYellow
        setViewControllers([
            createListViewController(),
        ], animated: false)
    }
    private func createListViewController() -> UIViewController {
        let listViewModel = ListViewModel()
        let listViewController = ListViewController(viewModel: listViewModel)
        listViewController.tabBarItem = .init(title: L10n.list, image: UIImage(systemName: "list.bullet"), tag: 0)
        listViewController.modalPresentationStyle = .fullScreen
        return listViewController
    }
}
