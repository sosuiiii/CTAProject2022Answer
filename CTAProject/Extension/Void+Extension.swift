// RxSwiftは関数型プログラミングな部分もあるので、
// その中でmap変換によってVoidにしたいときなどに活用する
// .hoge  // String
// .map(void)   // Void
// .bind(to: viewStream.voidInput)
// .disposed(by: disposeBag)
func void<E>(_: E) {}
