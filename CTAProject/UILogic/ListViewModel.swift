import RealmSwift
import RxCocoa
import RxDataSources
import RxSwift
import RxRelay
import Unio
import PKHUD
import RealmSwift

final class ListViewModel: UnioStream<ListViewModel>, ListViewModelType {
    convenience init(hotPepperRepository: HotPepperRepositoryType = HotPepperRepository(),
                     realmManager: RealmManagerType = RealmManager()) {
        self.init(input: Input(),
                  state: State(),
                  extra: Extra(hotPepperRepository: hotPepperRepository,
                               realmManager: realmManager)
        )
    }
    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {

        let input = dependency.inputObservables
        let state = dependency.state
        let extra = dependency.extra

        input.searchTextInput
            .subscribe(onNext: { text in
                if text.count > 50 {
                    state.alertType.accept(.textCountOver)
                    state.validatedText.accept("\(text.prefix(50))")
                } else {
                    state.validatedText.accept(text)
                }
            }).disposed(by: disposeBag)

        input.searchButtonTapped
            .flatMapLatest({ text -> Observable<Event<HotPepperResponse>> in
                state.hud.accept(.progress)
                return extra.hotPepperRepository.search(keyValue: ["keyword": text])
                    .timeout(.milliseconds(5000), scheduler: ConcurrentMainScheduler.instance)
                    .materialize()
            }).subscribe(onNext: { event in
                switch event {
                case .next(let response):
                    state.datasource.accept([HotPepperResponseDataSource(items: response.results.shop)])
                    state.dismissHUD.accept(())
                case .error:
                    state.hud.accept(.error)
                default:
                    state.dismissHUD.accept(())
                }
            }).disposed(by: disposeBag)

        // MARK: - HUD表示は 0.7秒後 にdismissする
        state.hud
            .delay(RxTimeInterval.milliseconds(700),
                   scheduler: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { _ in
                state.dismissHUD.accept(())
            }).disposed(by: disposeBag)

        input.saveFavorite.subscribe(onNext: { shop in
            let object = ShopObject(shop: shop)
            extra.realmManager.addEntity(object: object) { status in
                switch status {
                case .success:
                    state.hud.accept(.success)
                case .error:
                    state.hud.accept(.error)
                }
            }
        }).disposed(by: disposeBag)

        input.deleteObject.subscribe(onNext: { objectName in
            extra.realmManager.deleteOneObject(type: ShopObject.self, name: objectName) { status in
                switch status {
                case .success:
                    state.hud.accept(.success)
                case .error:
                    state.hud.accept(.error)
                }
            }
        }).disposed(by: disposeBag)

        return Output(alert: state.alertType.asObservable(),
                      validatedText: state.validatedText.asObservable(),
                      datasource: state.datasource.asObservable(),
                      hud: state.hud.asObservable(),
                      dismissHUD: state.dismissHUD.asObservable()
        )
    }

}
extension ListViewModel {

    struct Input: InputType {
        let searchTextInput = PublishRelay<String>()
        let searchButtonTapped = PublishRelay<String>()
        let saveFavorite = PublishRelay<Shop>()
        let deleteObject = PublishRelay<String>()
    }

    struct Output: OutputType {
        let alert: Observable<AlertType>
        let validatedText: Observable<String>
        let datasource: Observable<[HotPepperResponseDataSource]>
        let hud: Observable<HUDContentType>
        let dismissHUD: Observable<Void>
    }

    struct Extra: ExtraType {
        let hotPepperRepository: HotPepperRepositoryType
        let realmManager: RealmManagerType

        init(hotPepperRepository: HotPepperRepositoryType,
             realmManager: RealmManagerType) {
            self.hotPepperRepository = hotPepperRepository
            self.realmManager = realmManager
        }
    }

    struct State: StateType {
        let alertType = PublishRelay<AlertType>()
        let validatedText = PublishRelay<String>()
        let datasource = BehaviorRelay<[HotPepperResponseDataSource]>(value: [])
        let hud = PublishRelay<HUDContentType>()
        let dismissHUD = PublishRelay<Void>()
    }
}
