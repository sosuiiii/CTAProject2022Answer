
import RxDataSources
// 差分更新をしてくれる RxDataSource に使うためのモデルを定義している
// 基本的にこの形で定義し、変更するのは itemsの型 だけで良い
struct HotPepperResponseDataSource {
    var items: [Shop]
}
extension HotPepperResponseDataSource: SectionModelType {
    init(original: HotPepperResponseDataSource, items: [Shop]) {
        self = original
        self.items = items
    }
}
