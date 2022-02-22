
import RealmSwift
import RxCocoa
import RxDataSources
import RxSwift
import RxRelay
import Unio
import PKHUD

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

        // MARK: - HUD表示は 0.7秒後 にdismissする
        state.hud
            .delay(RxTimeInterval.milliseconds(700),
                   scheduler: ConcurrentMainScheduler.instance)
            .filter { $0 == .error }
            .map(void)
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
        let hotPepperRepository: HotPepperRepositoryType

        init(hotPepperRepository: HotPepperRepositoryType) {
            self.hotPepperRepository = hotPepperRepository
        }
    }

    struct State: StateType {
        let datasource = BehaviorRelay<[FavoriteHotPepperObjectsDataSource]>(value: [])
        let hud = PublishRelay<HUDContentType>()
        let dismissHUD = PublishRelay<Void>()
    }
}
