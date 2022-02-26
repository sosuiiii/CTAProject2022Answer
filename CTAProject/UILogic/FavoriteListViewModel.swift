
import RealmSwift
import RxCocoa
import RxDataSources
import RxSwift
import RxRelay
import Unio
import PKHUD

// Unioを使ったViewModelデザインパターン
// 強制的に書けるので統一性が上がる
final class FavoriteListViewModel: UnioStream<FavoriteListViewModel>, FavoriteListViewModelType {
    convenience init(hotPepperRepository: HotPepperRepositoryType = HotPepperRepository()) {
        self.init(input: Input(),
                  state: State(),
                  extra: Extra(hotPepperRepository: hotPepperRepository)
        )
    }
    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {

        let input = dependency.inputObservables
        let state = dependency.state
        let extra = dependency.extra

        // 本当はrealmを購読して更新するのが一番良い
        input.viewWillAppear.subscribe(onNext: {
            let datasource = getFavoriteHotPepperObjectsDataSource(hotPepperRepository: extra.hotPepperRepository)
            state.datasource.accept(datasource)
        }).disposed(by: disposeBag)

        input.deleteObject.subscribe(onNext: { objectName in
            extra.hotPepperRepository.deleteOneObject(type: ShopObject.self, name: objectName) { status in
                switch status {
                case .success:
                    state.hud.accept(.success)
                    let datasource = getFavoriteHotPepperObjectsDataSource(hotPepperRepository: extra.hotPepperRepository)
                    state.datasource.accept(datasource)
                case .error:
                    state.hud.accept(.error)
                }
            }
        }).disposed(by: disposeBag)

        // MARK: - HUD.error表示は 0.7秒後 にdismissする
        state.hud
            .delay(RxTimeInterval.milliseconds(700),
                   scheduler: ConcurrentMainScheduler.instance)
            .filter { $0 == .error }
            .map(void) // mapは型変換にも使える。 HUDContentType -> Void。このvoidはExtensionで定義した関数。
            .bind(to: state.dismissHUD)
            .disposed(by: disposeBag)


        return Output(datasource: state.datasource.asObservable(),
                      hud: state.hud.asObservable(),
                      dismissHUD: state.dismissHUD.asObservable()
        )
    }
    static func getFavoriteHotPepperObjectsDataSource(hotPepperRepository: HotPepperRepositoryType) -> [FavoriteHotPepperObjectsDataSource] {
        let objects = hotPepperRepository.getEntityList(type: ShopObject.self)
        let datasource = [FavoriteHotPepperObjectsDataSource(items: objects)]
        return datasource
    }

}
extension FavoriteListViewModel {

    struct Input: InputType {
        let deleteObject = PublishRelay<String>()
        let viewWillAppear = PublishRelay<Void>()
    }

    struct Output: OutputType {
        let datasource: Observable<[FavoriteHotPepperObjectsDataSource]>
        let hud: Observable<HUDContentType>
        let dismissHUD: Observable<Void>
    }

    struct Extra: ExtraType {
        // 外部に依存しているものをここに定義する。
        // DIしているものなどがその例
        // 依存していない定数はConstに定義
        let hotPepperRepository: HotPepperRepositoryType

        init(hotPepperRepository: HotPepperRepositoryType) {
            self.hotPepperRepository = hotPepperRepository
        }
    }

    struct State: StateType {
        // Input の状態を Stateに保持し、 Stateを Outputに渡す
        let datasource = BehaviorRelay<[FavoriteHotPepperObjectsDataSource]>(value: [])
        let hud = PublishRelay<HUDContentType>()
        let dismissHUD = PublishRelay<Void>()
    }
}
