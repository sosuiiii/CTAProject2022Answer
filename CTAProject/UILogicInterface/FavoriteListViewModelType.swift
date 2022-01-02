
import Unio

protocol FavoriteListViewModelType: AnyObject {
    var input: InputWrapper<FavoriteListViewModel.Input> { get }
    var output: OutputWrapper<FavoriteListViewModel.Output> { get }
}
