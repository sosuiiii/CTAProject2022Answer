
import RxCocoa
import RxDataSources
import RxSwift
import RxRelay
import Unio
import PKHUD

protocol ListViewModelType: AnyObject {
    var input: InputWrapper<ListViewModel.Input> { get }
    var output: OutputWrapper<ListViewModel.Output> { get }
}

final class ListViewModel: UnioStream<ListViewModel>, ListViewModelType {
    convenience init() {
        self.init(input: Input(),
                  state: State(),
                  extra: Extra()
        )
    }
    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {

        let input = dependency.inputObservables
        let state = dependency.state

        input.searchTextInput
            .subscribe(onNext: { text in
                print(text.count)
                if text.count > 50 {
                    state.alertType.accept(.textCountOver)
                } else {
                    state.validatedText.accept(text)
                }
            }).disposed(by: disposeBag)

        input.searchButtonTapped
            .flatMapLatest({ text -> Observable<Event<HotPepperResponse>> in
                HotPepperRepository.search(keyValue: ["keyword": text]).materialize()
            }).subscribe(onNext: { event in
                switch event {
                case .next(let response):
                    state.datasource.accept([HotPepperResponseDataSource(items: response.results.shop)])
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
            RealmManager.addEntity(object: object) { status in
                switch status {
                case .success:
                    state.hud.accept(.success)
                case .error:
                    state.hud.accept(.error)
                }
            }
            print("EntityList:\(RealmManager.getEntityList(type: ShopObject.self))")
        }).disposed(by: disposeBag)

        input.deleteObject.subscribe(onNext: { objectName in
            RealmManager.deleteOneObject(type: ShopObject.self, name: objectName) { status in
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
    }

    struct State: StateType {
        let alertType = PublishRelay<AlertType>()
        let validatedText = BehaviorRelay<String>(value: "")
        let datasource = BehaviorRelay<[HotPepperResponseDataSource]>(value: [])
        let hud = PublishRelay<HUDContentType>()
        let dismissHUD = PublishRelay<Void>()
    }
}
