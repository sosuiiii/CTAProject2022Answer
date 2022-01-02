
import Unio

protocol ListViewModelType: AnyObject {
    var input: InputWrapper<ListViewModel.Input> { get }
    var output: OutputWrapper<ListViewModel.Output> { get }
}
