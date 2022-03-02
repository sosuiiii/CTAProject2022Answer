
import UIKit
import RxSwift
import RxCocoa

class AlertView: UIView {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    private var disposeBag = DisposeBag()

    init(message: String) {
        super.init(frame: UIScreen.main.bounds)
        initializeView()
        setup(message: message)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeView() {
        let view = Bundle.main.loadNibNamed(String(describing: AlertView.self), owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
    }

    private func setup(message: String) {
        self.message.text = message
        doneButton.setTitle(L10n.close, for: .normal)
        cancelButton.isHidden = true

        Observable.merge(doneButton.rx.tap.asObservable(), cancelButton.rx.tap.asObservable())
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { me, _ in
                me.dismiss()
            }).disposed(by: disposeBag)
    }

    private func dismiss() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        self.window?.layer.add(transition, forKey: kCATransition)
        self.removeFromSuperview()
    }
}
