
import RxDataSources
struct HotPepperResponseDataSource {
    var items: [Shop]
}
extension HotPepperResponseDataSource: SectionModelType {
    init(original: HotPepperResponseDataSource, items: [Shop]) {
        self = original
        self.items = items
    }
}
