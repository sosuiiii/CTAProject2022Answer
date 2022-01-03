
import RxDataSources
struct FavoriteHotPepperObjectsDataSource: Equatable {
    var items: [ShopObject]
}
extension FavoriteHotPepperObjectsDataSource: SectionModelType {
    init(original: FavoriteHotPepperObjectsDataSource, items: [ShopObject]) {
        self = original
        self.items = items
    }
}
