
import RxDataSources
// 差分更新をしてくれる RxDataSource に使うためのモデルを定義している
// 基本的にこの形で定義し、変更するのは itemsの型 だけで良い
struct FavoriteHotPepperObjectsDataSource: Equatable {
    var items: [ShopObject]
}
extension FavoriteHotPepperObjectsDataSource: SectionModelType {
    init(original: FavoriteHotPepperObjectsDataSource, items: [ShopObject]) {
        self = original
        self.items = items
    }
}
